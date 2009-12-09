#!/usr/bin/env ruby
#
#
class CName
  def initialize(target)
    @dn = "relativeDomainName=#{target},dc=websages,dc=com,ou=dns,dc=websages,dc=com"
    @objectClass = [ 'top', 'dNSZone' ] 
    @rdn = ""
    @dNSTTL = 86400
    @zoneName = "websages.com"
    @cNAMERecord = target
  end 

  
end
