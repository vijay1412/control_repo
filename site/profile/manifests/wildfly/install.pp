# Downloads and installs Wildfly from a remote source or a system package.
class profile::wildfly::install {
file {'/var/opt/wildfly' :
  ensure => directory,
  }
wildfly_download {
 source_url  => 'https://download.jboss.org/wildfly/14.0.1.Final/wildfly-14.0.1.Final.tar.gz',
destination_directory => /var/opt/wildfly
 }
 

