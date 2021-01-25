############################################
#WILD FLY ADDING JAVA PROFLE AND INSTALL
#############################################
class profile::wildfly::server::install(
){

#INSTALL JDK
class { '::profile::java::jdk':
  type => $profile::wildfly::server::jdk_type,
  version => $profile::wildfly::server::jdk_version,
  }
  
class { 'wildfly':
  version        => '14.0.0',
  install_source => 'http://download.jboss.org/wildfly/14.0.0.Final/wildfly-14.0.0.Final.tar.gz',
  properties       => {
    'jboss.bind.address'            => '0.0.0.0',
    'jboss.bind.address.management' => '0.0.0.0',
    'jboss.management.http.port' => '9990',
    'jboss.management.https.port' => '9993',
    'jboss.http.port' => '8080',
    'jboss.https.port' => '8443',
    'jboss.ajp.port' => '8009',
  },
  #java_home => '$java_home',
  #java_home => '/usr/lib/jvm/java',
  #require => Class['::profile::java::jdk',],
  #conf_file      => '/etc/wildfly/wildfly.conf',
  #dirname           =>'/opt/wildfly/wildfly-14',
  dirname => Stdlib::Unixpath($profile::wildfly::server::wildfly_home),
  conf_template  => 'profile/wildfly/wildfly.systemd.conf.epp',
  java_opts      => '-Djava.net.preferIPv4Stack=true'
}
~>
wildfly::restart { 'Restart required':
  retries => 2,
  wait    => 30,
}
#wildfly::undertow::https { 'https':
 # socket_binding    => 'https',
  #keystore_path     => '/vagrant/identitystore.jks',
  #keystore_password => 'changeit',
  #key_alias         => 'demo',
  #key_password      => 'changeit'
#}
#wildfly::logging::category { 'org.jboss.deployment':
 # level               => 'DEBUG',
  #use_parent_handlers =>  true,
#}

}

