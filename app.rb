require 'open-uri'

BASE_URL = 'http://devcenter.heroku.com'

helpers do
  def scraping(url)
    doc = Nokogiri::HTML(open(url)).xpath('//section[@id="main"]')
    doc.xpath('//section/ul').each { |ul| ul['data-role'] = 'listview' }
    doc.xpath('//hgroup/p[@class="tags"]/a').each do |a|
      a['data-role'] = 'button'
      a['data-inline'] = 'true'
    end
    @header = doc.xpath('//hgroup/h1').remove.to_s
    @content = doc.inner_html
    nil
  end
end

get '/' do
  scraping(BASE_URL)
  @header = '<h1>devcenter</h1>'
  haml :page
end

get '/:path/:uri' do
  scraping("#{BASE_URL}/#{params[:path]}/#{params[:uri]}")
  haml :page, :layout => !request.xhr?
end

