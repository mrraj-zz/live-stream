class User < ActiveRecord::Base

  has_many :sessions

  def authenticate(password = nil)
    return false unless password
    self.password == password ? true : false
  end
end
