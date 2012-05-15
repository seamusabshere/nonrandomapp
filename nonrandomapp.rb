require 'bundler/setup'
require 'sinatra/base'
require 'redis'
require 'lock_method'

ENV['REDIS_URL'] ||= ENV['REDISTOGO_URL']

$redis = Redis.new
LockMethod.config.storage = $redis

require_relative 'app/cycle'

require 'sinatra/base'

class NonRandomApp < Sinatra::Base
  get '/' do
    %{You should try http://#{request.host_with_port}/cycles/ARBITRARY_ID?size=10}
  end

  get '/cycles/:id' do
    content_type 'text/plain'
    Cycle.new(params['id'], params.slice('size')).current.to_s
  end
end
