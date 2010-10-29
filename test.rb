#!/usr/bin/env ruby

require 'rubygems'
require 'active_ldap'
require 'pp'



class DnsEntry < ActiveLdap::Base
    ldap_mapping :dn_attribute => 'relativeDomainName', 
                 :prefix => 'dc=websages,dc=com,ou=DNS', 
                 :classes => ['top', 'dNSZone' ]
end


 ActiveLdap::Base.setup_connection(
     :host => 'freyr.websages.com',
     :port => 636,
     :method => :ssl,
     :base => 'dc=websages,dc=com',
     :bind_dn => "uid=stahnma,ou=people,dc=websages,dc=com",
     :password => ENV['LDAP_PASSWORD'],
     :allow_anonymous => false)


DnsEntry.find(:all , 'wiki').each do | host|
#  pp host
  puts host.dn
  puts host.zoneName
  puts host.dNSTTL
  puts host.cNAMERecord
end

DnsEntry.find(:all , 'brand').each do | host|
#  pp host
  puts host.dn
  puts host.zoneName
  puts host.dNSTTL
  puts host.cNAMERecord
end


#cname = DnsEntry.new('brand')
#cname.objectClass = [ 'top', 'dNSZone' ] 
#cname.zoneName = 'websages.com'
#cname.dNSTTL = 86400
#cname.relativeDomainName= 'brand'
#cname.cNAMERecord = 'tyr.websages.com.'
#cname.save!

