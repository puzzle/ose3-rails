require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'json'

get '/' do
  # Simulate a json log
  puts({ foo: 'bar' }.to_json)

  'works'
end
