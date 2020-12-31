class profile::wildfly::server::install (
)
 
class { 'wildfly':
  version        => '14.0.1',
  install_source => 'https://download.jboss.org/wildfly/14.0.1.Final/wildfly-14.0.1.Final.tar.gz',
}
