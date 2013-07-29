class LdapAuth

  def initialize(username = nil, password = nil)
    @username = username
    @password = password
    @host     = 'ldap.pramati.com'
    @base     = 'ou=Employees, dc=pramati, dc=com'
  end

  def authenticate?
    ldap = Net::LDAP.new(auth: { method: :simple, username: "uid=#{@username}, #{@base}", password: @password },
                         base: @base, host: @host)
    ldap.bind ? entities.first : nil
  end

  def entities(username = @username)
    filters    = Net::LDAP::Filter.eq('uid', username)
    ldap       = Net::LDAP.new(host: @host)
    ldap_entities   = []

    ldap.search(base: @base, filter: filters) do |entity|
      ldap_entities << LdapUser.new(entity.uid.first, entity.uid.first, entity.cn.first, 
                                    entity.baselocation.first, entity.mail.first)
    end
    ldap_entities
  rescue Exception => exception
    Rails.logger.info exception
  end
end
