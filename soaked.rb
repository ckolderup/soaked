require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'dm-migrations'

DataMapper.setup(:default, "sqlite://#{Dir.pwd}/soaked.db")

class Event
  include DataMapper::Resource
  property :id,     Serial
  property :player, Text
  property :message, Text
  property :timestamp, DateTime
end

DataMapper.auto_upgrade!

get '/' do
  @events = Event.all :limit => 10, :order => [:timestamp.desc]
  haml :events
end

get '/application.css' do
  headers 'Content-Type' => 'text/css; charset=utf-8'
  sass :style
end

post '/api/player/join' do
  @event = Event.new :player    => params[:playerName],
                     :timestamp => Time.now,
                     :message     => "#{params[:playerName]} joined."
  error 400 unless @event.save
end

post '/api/player/quit' do
  @event = Event.new :player    => params[:playerName],
                     :timestamp => Time.now,
                     :message   => "#{params[:playerName]} quit."
  error 400 unless @event.save
end

post '/api/player/death' do
  @event = Event.new :player    => params[:playerName],
                     :timestamp => Time.now,
                     :message     => "#{params[:playerName]} died!"
  error 400 unless @event.save
end

