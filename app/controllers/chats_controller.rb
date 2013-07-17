require 'reloader/sse'

class ChatsController < ApplicationController
  include ActionController::Live
  before_filter :current_channel

  def index
  end

  def create
    response.headers['Content-Type'] = 'text/javascript'
    $redis.publish(@channel.name, { "message" => params[:message]}.to_json)
    render nothing: true
  end

  def chat
    response.headers['Content-Type'] = 'text/event-stream'
    sse = Reloader::SSE.new(response.stream)
    redis = Redis.new

    redis.subscribe(@channel.name) do |on|
      on.message do |event, data|
        sse.write(JSON.parse(data), event: "push-message")
      end
    end
    render nothing: true
  rescue IOError
  ensure
    redis.quit
    sse.close
  end

  private
  def current_channel
    @channel = Channel.find(params[:channel_id])
  end
end
