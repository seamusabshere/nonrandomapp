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
    %{You should try http://#{request.host_with_port}/cycles/YOURSECRET&max=10}
  end

  get '/cycles/:id' do
    Cycle.new(params[:id], params.slice(:max)).current.to_s
  end
end
