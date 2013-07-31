class Channel < ActiveRecord::Base

  def subscribed?(member)
    $redis.sismember(name, member.id)
  end

  def members
    $redis.smembers(name)
  end

  def add_member(member)
    $redis.sadd(name, member.id) if not subscribed?(member)
  end
end
