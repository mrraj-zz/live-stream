class User < ActiveRecord::Base

  def authenticate(password = nil)
    return false unless password
    self.password == password ? true : false
  end
end
