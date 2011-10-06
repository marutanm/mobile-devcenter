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
end

get '/' do
  @url = BASE_URL
  scraping(@url)
  @header = '<h1>devcenter</h1>'
  haml :root
end

get '/:path/:uri' do
  @url = "#{BASE_URL}/#{params[:path]}/#{params[:uri]}"
  scraping(@url)
  haml :page, :layout => !request.xhr?
end

