require 'reloader/sse'

class ChatsController < ApplicationController
  include ActionController::Live

  before_action :set_channel
  before_action :subscribe_member, :channel_members, only: [:index]

  def index
  end

  def create
    response.headers['Content-Type'] = 'text/javascript'
    RedisServer.instance.push_message(@channel, current_user, { :message => params[:message] })
    render nothing: true
  end

  def chat
    response.headers['Content-Type'] = 'text/event-stream'
    sse = Reloader::SSE.new(response.stream)
    redis = Redis.new

    redis.subscribe(@channel.name) do |on|
      on.message do |event, data|
        parsed_data = JSON.parse(data)
        sse.write(parsed_data, event: parsed_data["event"] || "push-message")
      end
    end
    render nothing: true
  rescue IOError
  ensure
    redis.quit
    sse.close
  end

  def exit_chatroom
    RedisServer.instance.unsubscribe(@channel, current_user)
    redirect_to channels_path
  end

  private
  def set_channel
    @channel = Channel.find(params[:channel_id])
  end

  def subscribe_member
    RedisServer.instance.subscribe(@channel, current_user)
  end

  def channel_members
    @channel_members = RedisServer.instance.members(@channel)
  end
end
