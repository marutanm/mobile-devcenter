require 'open-uri'

BASE_URL = 'http://devcenter.heroku.com/'

get '/' do
  doc = Nokogiri::HTML(open(BASE_URL))
  @contents = doc.xpath('//section[@id="main"]').to_s
  haml :articles
end

get '/articles/:uri' do
  doc = Nokogiri::HTML(open("#{BASE_URL}#{params[:uri]}"))
  @contents = doc.xpath('//section[@id="main"]').to_s
  haml :articles
end

