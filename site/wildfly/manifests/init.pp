class wildfly {
file {'/var/opt/wildfly' :
  ensure => directory,
  }

 file {'/var/opt/wildfly/wildfly-14.0.1.Final.tar.gz':
 ensure =>file
 source => https://download.jboss.org/wildfly/14.0.1.Final/wildfly-14.0.1.Final.tar.gz
 }
 package {'java':
 ensure => present,
 }
 }
