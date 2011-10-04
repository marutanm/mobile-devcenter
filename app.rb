require 'open-uri'

BASE_URL = 'http://devcenter.heroku.com'

helpers do
  def scraping(url)
    doc = Nokogiri::HTML(open(url)).xpath('//section[@id="main"]')
    doc.xpath('//ul').each { |ul| ul['data-role'] = 'listview' }
    doc.inner_html
  end
end

get '/' do
  @contents = scraping(BASE_URL)
  haml :contents
end

get '/:path/:uri' do
  @contents = scraping("#{BASE_URL}/#{params[:path]}/#{params[:uri]}")
  haml :contents, :layout => !request.xhr?
end

