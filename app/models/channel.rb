class Channel < ActiveRecord::Base

  def subscribed?(member)
    $redis.sismember(name, member.id)
  end

  def members
    $redis.smembers(name)
  end

  def add_member(member)
    $redis.sadd(name, member.id) if not subscribed?(member)
    $redis.publish(name, { "message"  => "#{member.username} is entering into the chat room", 
                           "username" => member.username, 
                           "bg_color" => "bg-color-green",
                           "time"     => Time.now.strftime("%T")}.to_json)
  end
end
