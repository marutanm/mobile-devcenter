require 'open-uri'

BASE_URL = 'http://devcenter.heroku.com/'

helpers do
  def scraping(url)
    Nokogiri::HTML(open(url)).xpath('//section[@id="main"]').to_s
  end
end

get '/' do
  @contents = scraping(BASE_URL)
  haml :articles
end

get '/articles/:uri' do
  @contents = scraping("#{BASE_URL}#{params[:uri]}")
  haml :articles, :layout => !request.xhr?
end

