require 'reloader/sse'

class LiveStreamsController < ApplicationController
  include ActionController::Live

  def index
  end

  def create
    response.headers['Content-Type'] = 'text/javascript'
    $redis.publish("Public-RoR", { "message" => params[:message]}.to_json)
    render nothing: true
  end

  def chat_message
    response.headers['Content-Type'] = 'text/event-stream'
    sse = Reloader::SSE.new(response.stream)
    redis = Redis.new

    redis.subscribe("Public-RoR") do |on|
      on.message do |event, data|
        sse.write(JSON.parse(data), event: "Public-RoR")
      end
    end
    render nothing: true
  rescue IOError
  ensure
    redis.quit
    sse.close
  end
end
