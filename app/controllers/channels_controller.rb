class ChannelsController < ApplicationController
  before_action :set_channel, only: [:subscribe, :unsubscribe]

  def index
    @channels = Channel.scoped
  end

  private
  def set_channel
    @channel = Channel.find(params[:id])
  end
end
