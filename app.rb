require 'sinatra'
require 'nokogiri'
require 'open-uri'

get '/articles/:uri' do
    doc = Nokogiri::HTML(open("http://devcenter.heroku.com/articles/#{params[:uri]}"))
    p doc.xpath('//section[@id="main"]')
end
