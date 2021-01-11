class profile::wildfly::server::install {
class { 'wildfly':
  version        => '14.0.0',
  install_source => 'http://download.jboss.org/wildfly/14.0.0.Final/wildfly-14.0.0.Final.tar.gz',
  properties       => {
    'jboss.bind.address'            => '0.0.0.0',
    'jboss.bind.address.management' => '0.0.0.0',
  },
  conf_file      => '/etc/default/wildfly.conf',
  java_opts      => '-Djava.net.preferIPv4Stack=true'
}
~>
wildfly::restart { 'Restart required':
  retries => 2,
  wait    => 30,
}
wildfly::undertow::https { 'https':
  socket_binding    => 'https',
  keystore_path     => '/vagrant/identitystore.jks',
  keystore_password => 'changeit',
  key_alias         => 'demo',
  key_password      => 'changeit'
}

}
