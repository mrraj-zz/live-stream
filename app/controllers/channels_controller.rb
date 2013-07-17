class ChannelsController < ApplicationController
  before_filter :find_channel, only: [:subscribe, :unsubscribe]

  def index
    @channels = Channel.scoped
  end

  def subscribe
    $redis.sadd(@channel.name, current_user.id)
    redirect_to channels_path, notice: 'Subscribed successfully.'
  end

  def unsubscribe
    $redis.srem(@channel.name, current_user.id)
    redirect_to channels_path, notice: 'Unsubscribed successfully.'
  end

  private
  def find_channel
    @channel = Channel.find(params[:id])
  end
end
