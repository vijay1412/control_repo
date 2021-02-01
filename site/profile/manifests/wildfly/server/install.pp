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
  java_home => Stdlib::Unixpath($profile::java::jdk::java_home),
  config            => 'standalone-full-ha.xml',
  #require => Class['::profile::java::jdk',],
  #conf_file      => '/etc/wildfly/wildfly.conf',
  #dirname           =>'/opt/wildfly/wildfly-14',
  dirname => Stdlib::Unixpath($profile::wildfly::server::wildfly_home),
  #conf_template  => 'profile/wildfly/wildfly.systemd.conf.epp',
   java_opts      =>   "'-Djava.net.preferIPv4Stack=true'
                       '-Djava.net.preferIPv4Addresses=true'
                       '-Djboss.default.jgroups.stack=tcp'
                       '-Djavax.net.ssl.tomcatkeystorefile=${profile::wildfly::server::java_keystore_file}'
                        '-Djavax.net.ssl.keyStorePassword =changeit'",
  }
#~>
#wildfly::restart { 'Restart required':
 # retries => 2,
  #wait    => 30,
#}
wildfly::undertow::https { 'https':
  socket_binding    => 'https',
  #keystore_path     => ($profile::wildfly::server::java_keystore_file),
  keystore_path => $tomcatkeystorefile,
  keystore_password => 'changeit'
}
wildfly::logging::category { 'org.jboss.deployment':
  level               => 'DEBUG',
  use_parent_handlers =>  true,
}
wildfly::logging::category { 'org.jgroups':
  level               => 'INFO',
}
# -> wildfly::resource { '/socket-binding-group=standard-sockets/remote-destination-outbound-socket-binding=proxy1':
 #   content => {
  #    'host' => '172.28.128.10',
   #   'port' => '6666'
    #}
  #}

#wildfly::resource { '/subsystem=undertow/server=default-server/ajp-listener=ajp':
     #path  => "/subsystem=undertow/server=default-server/ajp-listener=ajp",
  #   operat => {
      #  ensure => 'present',
        #operation_headers   => {
         # 'max-post-size' => '2000',
    #},
   #}
   
    wildfly::resource { '/subsystem=undertow/server=default-server/ajp-listener=ajp':
    content => {
      'max-post-size'        => 20000000,
      'scheme' =>https,
       'max-ajp-packet-size' =>65536,
        }
       }
        wildfly::resource { '/subsystem=undertow/servlet-container=default/setting=jsp':
    content => {
      'tag-pooling' => false,
      'trim-spaces' => true,
      'generate-strings-as-char-arrays' => true,
        }
       }
     # wildfly::jgroups::stack::tcpgossip { 'TCPGOSSIP':
     #initial_hosts       => '${amfam.nhq.gossip.router}[7777] ,${amfam.grl.gossip.router}[7777]',
     #num_initial_members => 2,
     
     wildfly::resource { '/subsystem=jgroups/stack=tcpgossip:add'
  
        }

   }
