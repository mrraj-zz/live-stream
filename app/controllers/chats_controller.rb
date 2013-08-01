require 'reloader/sse'

class ChatsController < ApplicationController
  include ActionController::Live

  before_action :set_channel

  def index
    @channel.add_member(current_user)
  end

  def create
    response.headers['Content-Type'] = 'text/javascript'
    $redis.publish(@channel.name, { "message"  => params[:message], 
                                    "username" => current_user.username, 
                                    "bg_color" => "bg-color-#{current_user.username.length % 5}",
                                    "time"     => Time.now.strftime("%T"),
                                    "event"    => "push-message" }.to_json)
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
    @channel.remove_member(current_user)
    redirect_to channels_path
  end

  private
  def set_channel
    @channel = Channel.find(params[:channel_id])
  end
end
