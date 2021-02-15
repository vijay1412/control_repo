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
  version        => '14.0.1',
  install_source => 'http://download.jboss.org/wildfly/14.0.1.Final/wildfly-14.0.1.Final.tar.gz',
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
                       '-Damfam.nhq.gossip.router=nhqdevjbossgr'
                       '-Damfam.grl.gossip.router=grldevjbossgr'
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
       
      wildfly::resource { '/socket-binding-group=standard-sockets/remote-destination-outbound-socket-binding=jgroups-host-a':
   #ensure => present,
   content => {
      'host' => '${amfam.nhq.gossip.router}',
      'port' => 8888,
        }
        }
    wildfly::resource { '/socket-binding-group=standard-sockets/remote-destination-outbound-socket-binding=jgroups-host-b':
   # ensure => present,
    content => {
      'host' => '${amfam.grl.gossip.router}',
      'port' => 8888,
        }
       }
   
   ~> wildfly::reload { 'reload': }
  
 wildfly::resource { "/subsystem=jgroups/stack=tcpgossip":
    recursive => true,
    content   => {
      #'protocol' => 'TCPGOSSIP',
      'transport' => {
      'TCP' => {
        'socket-binding' => 'jgroups-tcp',
      }
    }

    }
  }
# wildfly::resource {"/socket-binding-group=standard-sockets/socket-binding=jgroups-tcp":
 #content => {
  #    interface => "\$jboss.bind.address",
   #    }
    #    }
    
  #wildfly::resource { "/subsystem=jgroups/stack=tcpgossip/protocol=org.jgroups.protocols.TCPGOSSIP":
  # ensure => absent, 
   # }  
   
  wildfly::resource { "/subsystem=jgroups/stack=tcpgossip/protocol=TCPGOSSIP":
   ensure => present,
    content => {
     socket-bindings => '['jgroups-host-a,jgroups-host-b']',
    
        }
        }
    wildfly::resource { "/subsystem=jgroups/stack=tcpgossip/protocol=MERGE3":
    ensure => present,
    }
    wildfly::resource { "/subsystem=jgroups/stack=tcpgossip/protocol=FD_SOCK":
    ensure =>present,
    }
    
    wildfly::resource { "/subsystem=jgroups/stack=tcpgossip/protocol=FD_ALL":
    ensure => present,
    }
 wildfly::resource { "/subsystem=jgroups/stack=tcpgossip/protocol=VERIFY_SUSPECT":
    ensure => present,
    }   
    
    wildfly::resource { "/subsystem=jgroups/stack=tcpgossip/protocol=pbcast.NAKACK2":
    ensure => present,
    }   
    wildfly::resource { "/subsystem=jgroups/stack=tcpgossip/protocol=UNICAST3":
    ensure => present,
    }   
    wildfly::resource { "/subsystem=jgroups/stack=tcpgossip/protocol=pbcast.STABLE":
    ensure => present,
    }   
  wildfly::resource { "/subsystem=jgroups/stack=tcpgossip/protocol=pbcast.GMS":
    ensure => present,
    }   
    
    wildfly::resource { "/subsystem=jgroups/stack=tcpgossip/protocol=MFC":
    ensure => present,
    }   
     wildfly::resource { "/subsystem=jgroups/stack=tcpgossip/protocol=FRAG2":
    ensure => present,
    }   
    wildfly::resource { "/subsystem=jgroups/channel=ee":
     content => {
      'stack' => 'tcpgossip',
        }
    }   
       
       
  wildfly::resource { '/subsystem=infinispan/cache-container=web/transport=TRANSPORT':
 content => {
 cluster => '${jboss.partition.name:DefaultPartition}-web',
 
   }
   }
wildfly::resource { '/subsystem=infinispan/cache-container=ejb/transport=TRANSPORT':
 content => {
 cluster => '${jboss.partition.name:DefaultPartition}-ejb',
 
   }
   }
   
   wildfly::resource { '/subsystem=infinispan/cache-container=hibernate/transport=TRANSPORT':
 content => {
 cluster => '${jboss.partition.name:DefaultPartition}-hibernate',
 
   }
   }
        wildfly::resource {'/subsystem=messaging-activemq/server=default':
       # ensure => present,
        content => {
       'cluster-user'=> '${jboss.partition.name:DefaultPartition}',
      # 'cluster-password'=> 'changeme'
       }
       }   
       
     wildfly::resource {'/subsystem=messaging-activemq/server=default/broadcast-group=bg-group1':
       content => {
       'jgroups-cluster' => 'activemq-cluster-${jboss.partition.name:DefaultPartition}'
       }
       }   
       
       wildfly::resource {'/subsystem=messaging-activemq/server=default/discovery-group=dg-group1':
       content => {
       'jgroups-cluster' => 'activemq-cluster-${jboss.partition.name:DefaultPartition}'
       }
       }
       
    wildfly::resource { '/subsystem=infinispan/cache-container=web/replicated-cache=repl':
    # 'mode' => 'ASYNC'
     #}
     }
     
     wildfly::resource { '/subsystem=infinispan/cache-container=web/replicated-cache=repl/store=file':

     }

   #}
  # ~> wildfly::reload { 'reload': }
    wildfly::resource { '/subsystem=infinispan/cache-container=web/replicated-cache=repl/component=transaction':
    content => {
    'mode' => 'BATCH'
     }
     }
     
      wildfly::resource { '/subsystem=infinispan/cache-container=web/replicated-cache=repl/component=locking':
    content => {
    'isolation' => 'REPEATABLE_READ'
     }
     }
   
     wildfly::resource { '/subsystem=infinispan/cache-container=web':
     content => {
     'default-cache'=> 'repl'
     }
  
     }
     }

 
 
