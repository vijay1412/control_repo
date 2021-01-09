###############################################################################
# PROFILE TO MANAGE LOGICAL VOLUME CONFIGURATIONS FOR TOMCAT
###############################################################################

#
# Reference:
#   https://forge.puppet.com/puppetlabs/lvm
# Dependencies:
#   mod 'puppetlabs-lvm', '1.0.1'
#
class profile::wildfly::server::filesystems(
)
file { '/var/cache/wget':
    ensure => directory,
    mode   => '0755',
    backup => false,
}


  
