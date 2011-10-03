require 'open-uri'

get '/articles/:uri' do
  doc = Nokogiri::HTML(open("http://devcenter.heroku.com/articles/#{params[:uri]}"))
  @contents = doc.xpath('//section[@id="main"]').to_s
  haml :articles
end

