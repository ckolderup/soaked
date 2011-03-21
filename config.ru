require 'rubygems'
require 'bundler'

Bundler.require

require './soaked'
run Sinatra::Application 
