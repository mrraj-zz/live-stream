class RedisServer
  include Singleton

  def initialize
    @redis = Redis.new
  end

  def push_message(channel, member, options = {})
    @redis.publish(channel.name, queue_data(member).merge(options).to_json)
  end

  def subscribed?(channel, member)
    @redis.sismember(channel.name, member.id)
  end

  def members(channel)
    @redis.smembers(channel.name)
  end

  def subscribe(channel, member)
    @redis.sadd(channel.name, member.id)
    push_message(channel, member, sub_unsub_options(channel)
                 .merge(:message => "#{member.username} is entering into this chat room"))
  end

  def unsubscribe(channel, member)
    @redis.srem(channel.name, member.id)
    push_message(channel, member, sub_unsub_options(channel)
                 .merge(:message => "#{member.username} is exiting from this chat room"))
  end

  private
  def queue_data(member)
    { :username => member.username, 
      :time     => Time.now.strftime("%T") ,
      :bg_color => "bg-color-#{member.username.length % 5}",
      :event    => "push-message" }
  end

  def sub_unsub_options(channel)
    { :event    => "enter-exit-chatroom",
      :members  => members(channel),
      :bg_color => "bg-color-normal" }
  end
end
