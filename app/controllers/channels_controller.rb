class ChannelsController < ApplicationController
  before_action :set_channel, only: [:subscribe, :unsubscribe]

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
  def set_channel
    @channel = Channel.find(params[:id])
  end
end
