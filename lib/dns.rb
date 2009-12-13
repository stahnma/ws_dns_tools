#!/usr/bin/env ruby


class DNSEntry

  def initialize(rdn)
    @objectClass = [  'top', 'dNSZone' ] 
    @zoneName = 'websages.com'
    @relativeDomainName = rdn
    @dn = ""
  end

  def publish
    # write it to LDAP
    require 'ldap'
    conn = LDAP::SSLConn.new('freyr.websages.com', 636)
    binddn = 'uid=stahnma,ou=people,dc=websages,dc=com'
    bindpw = 'xxxxxx'
    bound = conn.bind(binddn, bindpw)
    #bound.add(@dn, attrs)
  end

  def build_attrs
  end
 
  def to_ldif
    str = "dn: #{@dn}\n"
    self.instance_variables.each do |iv|
      next if iv =~ /@dn/
      label = iv.sub('@', '')
      if self.instance_variable_get(iv).kind_of?(Array)
        self.instance_variable_get(iv).each do |item|
          str += "#{label}: " + item.to_s + "\n"
        end
      else
        str += "#{label}: " + self.instance_variable_get(iv).to_s + "\n"
      end
    end 
    str
  end
end

class CName < DNSEntry
  def initialize(cname, target, ttl = 86400)
    super(cname)
    @dn = "relativeDomainName=#{cname},dc=websages,dc=com,ou=dns,dc=websages,dc=com"
    @relativeDomainName = cname
    @dNSTTL = ttl
    @cNAMERecord = target
  end 
end


a = CName.new('git', 'tyr.websages.com.')
puts a.to_ldif
