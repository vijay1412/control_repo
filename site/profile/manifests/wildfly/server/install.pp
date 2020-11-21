class profile::wildfly::server::install (
$wildfly_home = /var/opt/home
){
#Download 
archive { "wildfly-14.0.1.Final.tar.gz":
ensure => present ,
source => "https://download.jboss.org/wildfly/14.0.1.Final/wildfly-14.0.1.Final.tar.gz",
target => $profile::wildfly::server::wildfly_home,
required => File [$profile::wildfly::server::wildfly_home],
}
    
