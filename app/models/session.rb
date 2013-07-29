class Session < ActiveRecord::Base
  belongs_to :user

  def self.online_users
    where("username IS NOT NULL").collect{ |session| session.username }
  end
end
