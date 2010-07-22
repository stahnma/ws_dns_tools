#!/usr/bin/env ruby

class DNSEntry
  require 'yaml'
  require 'ldap'

  def initialize(rdn)
    @objectClass = [  'top', 'dNSZone' ] 
    @zoneName = 'websages.com'
    @relativeDomainName = rdn
    @dn = ""
  end

  def connect
    conn = LDAP::SSLConn.new('freyr.websages.com', 636)
    binddn = 'uid=stahnma,ou=people,dc=websages,dc=com'
    bindpw = ENV['LDAP_PASSWORD']
    @bound = conn.bind(binddn, bindpw)
  end

  def delete(dn)
    connect
    @bound.delete(dn)
  end

  def publish
    connect 
    @bound.add(@dn, build_attrs)
  end

  def exists?(dn)
    connect
    entries = @bound.search("dc=websages,dc=com", 0, dn)
    p entries.class
    p foo.to_hash
  end
  def build_attrs
    attrs = { }
    self.instance_variables.each do |iv|
      next if iv =~ /@dn/
      label = iv.sub('@', '')
      if self.instance_variable_get(iv).kind_of?(Array)
        attrs[label] =  self.instance_variable_get(iv)
      else
        attrs[label] =  [ self.instance_variable_get(iv).to_s ] 
      end
    end
    return attrs
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


a = CName.new('wiki3', 'tyr.websages.com.')
puts a.to_ldif
#a.publish()
#a.delete('relativeDomainName=wiki3,dc=websages,dc=com,ou=dns,dc=websages,dc=com')
a.exists?('relativeDomainName=wiki3,dc=websages,dc=com,ou=dns,dc=websages,dc=com')
#p a.build_attrs()
