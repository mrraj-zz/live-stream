class LdapUser
  
  attr_accessor :id, :username, :fullname, :location, :email

  def initialize(id, username, fullname, location, email)
    @id       = id
    @username = username
    @fullname = fullname
    @location = location
    @email    = email
  end

  class << self
    def find_user(username)
      LdapAuth.new(username).entities.first
    end
  end
end
