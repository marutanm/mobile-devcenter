require 'rubygems'
require 'bundler'
Bundler.require

require 'open-uri'
require 'json'

require './app.rb'
run Sinatra::Application
