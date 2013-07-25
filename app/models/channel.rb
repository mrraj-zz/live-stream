class Channel < ActiveRecord::Base

  def subscribed?(member)
    $redis.sismember(name, member.id)
  end

  def members
    User.find($redis.smembers(name))
  end
end
