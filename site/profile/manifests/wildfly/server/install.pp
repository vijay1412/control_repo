class profile::wildfly::server::install (
){
#Download 
archive { "${profile::wildfly::server::install_cache_dir}\\${profile::wildfly::server::wildfly_install_bundle}":
ensure      => present ,
source      => "https://download.jboss.org/wildfly/14.0.1.Final/wildfly-14.0.1.Final.tar.gz",
extarct_path => $profile::wildfly::server::wildfly_home,
extarct      => true,
}
}
