require 'rubygems'
require 'bundler'
Bundler.require

require 'open-uri'

require './app.rb'
run Sinatra::Application
