require 'reloader/sse'

class ChatsController < ApplicationController
  include ActionController::Live
  before_action :set_channel
  before_action :check_channel_members, only: [:index, :create, :chat]

  def index
  end

  def create
    response.headers['Content-Type'] = 'text/javascript'
    $redis.publish(@channel.name, { "message" => params[:message], "username" => current_user.email}.to_json)
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
  def set_channel
    @channel = Channel.find(params[:channel_id])
  end

  def check_channel_members
    unless @channel.subscribed?(current_user)
      redirect_to(channels_path, alert: "Please subscribe the channel, then only allowed to enter into chat room.")
    end
  end
end
