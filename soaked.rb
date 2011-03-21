require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'haml'
require 'sass'
require 'json'

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

get '/events/json' do
  content_type :json 
  @since = params[:since].nil? ? Time.at(0) : Time.at(params[:since].to_i)
  @before = params[:before].nil? ? Time.now : Time.at(params[:before].to_i)
  puts "since #{@since}, before #{@before}"
  @events = Event.all :timestamp.gt => @since,
                      :timestamp.lt => @before,
                      :limit => 10,
                      :order => [:timestamp.asc]
  @events.to_json
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

