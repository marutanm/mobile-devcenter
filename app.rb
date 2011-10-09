require 'open-uri'

BASE_URL = 'http://devcenter.heroku.com'

helpers do
  def scraping(url)
    doc = Nokogiri::HTML(open(url)).xpath('//section[@id="main"]')
    doc.xpath('//section/ul').each do |ul|
      ul['data-role'] = 'listview'
      ul['data-inset'] = 'true'
    end
    doc.xpath('//hgroup/p[@class="tags"]/a').each do |a|
      a['data-role'] = 'button'
      a['data-inline'] = 'true'
    end
    @header = doc.xpath('//hgroup/h1').remove.to_html
    @content = doc.inner_html
    nil
  end

  def scraping_search(url)
    form = Nokogiri::HTML::Builder.new do |doc|
      doc.form(:action => '/articles', :method => 'get') {
        doc.input(:type => "search", :id => "search", :name => 'q', :value => "#{url}".sub(/^q\=/, '').sub(/\+/, ' '))
      }
    end
    jsonhash = JSON.parse open("#{BASE_URL}/articles.json?#{url}").read
    ul = Nokogiri::HTML::Builder.new do |doc|
      doc.ul('data-role' => 'listview', 'data-inset' => 'true') {
        jsonhash['devcenter'].each do |v|
          doc.li {
            doc.a(:href => "/articles/#{v['article']['slug']}") {
              doc.text = v['article']['title']
            }
          }
        end
      }
    end
    @content = form.to_html + ul.to_html
    @header = '<h1>Search Results</h1>'
  end
end

get '/' do
  @url = BASE_URL
  scraping(@url)
  @header = '<h1>devcenter</h1>'
  haml :root
end

get '/articles' do
  @url = "#{BASE_URL}/articles?#{request.query_string}"
  scraping_search(request.query_string)
  haml :page, :layout => !request.xhr?
end

get '/:path/:uri' do
  @url = "#{BASE_URL}/#{params[:path]}/#{params[:uri]}"
  scraping(@url)
  haml :page, :layout => !request.xhr?
end

