require 'open-uri'

enable :inline_templates 

get '/articles/:uri' do
  doc = Nokogiri::HTML(open("http://devcenter.heroku.com/articles/#{params[:uri]}"))
  @contents = doc.xpath('//section[@id="main"]').to_s
  haml :articles
end

__END__

@@ layout
!!! 5
%link{:rel => 'stylesheet', :href => 'http://code.jquery.com/mobile/1.0rc1/jquery.mobile-1.0rc1.min.css'}
%script{:src => 'http://code.jquery.com/jquery-1.6.4.min.js'}
%script{:src => 'http://code.jquery.com/mobile/1.0rc1/jquery.mobile-1.0rc1.min.js'}
=yield

@@ articles
= @contents
