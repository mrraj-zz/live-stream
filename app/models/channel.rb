class Channel < ActiveRecord::Base

  def subscribed?(member)
    $redis.sismember(name, member.id)
  end

  def members
    $redis.smembers(name)
  end

  def add_member(member)
    $redis.sadd(name, member.id) if not subscribed?(member)
    push_message(member, "enter-exit-chatroom", :enter)
    push_message(member, "push-message", :enter)
  end

  def remove_member(member)
    $redis.srem(name, member.id) if subscribed?(member)
    push_message(member, "enter-exit-chatroom", :exit)
    push_message(member, "push-message", :exit)
  end

  private
  def push_message(member, event, status)
    $redis.publish(name, { "message"  => notification_message(member, status), 
                           "username" => "", 
                           "bg_color" => "bg-color-undefined",
                           "time"     => Time.now.strftime("%T"), 
                           "event"    => event, 
                           "members"  => members }.to_json)
  end

  def notification_message(member, event = :enter)
    case event
    when :enter
      "#{member.username} is entering into the chat room"
    when :exit
      "#{member.username} is exiting from the chat room"
    end
  end
end
