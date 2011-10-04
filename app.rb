require 'open-uri'

BASE_URL = 'http://devcenter.heroku.com'

helpers do
  def scraping(url)
    doc = Nokogiri::HTML(open(url)).xpath('//section[@id="main"]')
    doc.xpath('//ul').each { |ul| ul['data-role'] = 'listview' }
    @header = doc.xpath('//hgroup/h1').remove.to_s
    @contents = doc.inner_html
    nil
  end
end

get '/' do
  scraping(BASE_URL)
  haml :contents
end

get '/:path/:uri' do
  scraping("#{BASE_URL}/#{params[:path]}/#{params[:uri]}")
  haml :contents, :layout => !request.xhr?
end

