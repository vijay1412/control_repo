class profile::wildfly::server (
  $wildfly_home                                              = '/opt/wildfly/wildfly-14',
  $jdk_type = 'openjdk',
  $jdk_version = '1.8.0',
  Stdlib::Unixpath $console_log                               = '/var/log/wildfly/console.log',
  Stdlib::Unixpath $install_cache_dir                         = '/var/cache/wget',
  Stdlib::Unixpath $deploy_cache_dir                          = '/opt',
  $wildfly_install_bundle                                     = 'wildfly-14.0.0.Final.tar.gz',
  Boolean $manage_user                                        = true,
  String $user                                                = 'wildfly',
  Stdlib::Unixpath $user_home                                 = '/home/wildfly',
  String $java_xmx                                            = '512m',
  String $java_xms                                            = '256m',
  String $java_maxpermsize                                    = '128m',
  String $package_ensure                                      = 'present',
  Boolean $service_ensure                                    = true,
  Boolean $service_enable                                     = true,
  Boolean $remote_debug                                       = false,
  Boolean $external_facts                                     = false,
  Integer $remote_debug_port                                  = 8787,
  Integer $startup_wait                                       = 30,
  Integer $shutdown_wait                                      = 30,
  Integer $install_download_timeout                           = 500,
  $java_keystore_file ='/vagrant/identitystore.jks'
  ) {
   contain ::profile::wildfly::server::filesystems
   contain ::profile::wildfly::server::install
        Class['profile::wildfly::server::filesystems']
     -> Class['profile::wildfly::server::install']        
  }
