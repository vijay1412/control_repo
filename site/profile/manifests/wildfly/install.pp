class profile::wildfly::install (
){
#Download 
archive { "${profile::wildfly::wildfly_home}\\${profile::wildfly::wildfly-14.0.1.Final.tar.gz}":
ensure => present ,
source => "https://download.jboss.org/wildfly/14.0.1.Final/wildfly-14.0.1.Final.tar.gz",
target => $profile::wildfly::wildfly_home,
required => File [$profile::wildfly::wildfly_home,
}
    
