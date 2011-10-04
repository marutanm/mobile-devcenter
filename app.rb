require 'open-uri'

BASE_URL = 'http://devcenter.heroku.com'

helpers do
  def scraping(url)
    Nokogiri::HTML(open(url)).xpath('//section[@id="main"]').to_s
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

