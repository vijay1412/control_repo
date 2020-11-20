
class profile::wildfly (
  Pattern[/^(\d{1,}\.\d{1,}(\.\d{1,})?$)/] $version           = '9.0.2',
  Variant[Pattern[/^file:\/\//], Pattern[/^puppet:\/\//], Stdlib::Httpsurl, Stdlib::Httpurl] $install_source = "http://download.jboss.org/wildfly/${version}.Final/wildfly-${version}.Final.tar.gz",
  #Wildfly::Distribution $distribution                         = 'wildfly',
  Enum['sysvinit', 'systemd', 'upstart'] $init_system         = $facts['initsystem'],
  Stdlib::Unixpath $dirname                                   = '/var/opt/wildfly',
  Stdlib::Unixpath $java_home                                 = '/usr/java/default',
  Stdlib::Unixpath $console_log                               = '/var/log/wildfly/console.log',
  Stdlib::Unixpath $install_cache_dir                         = '/var/cache/wget',
  Stdlib::Unixpath $deploy_cache_dir                          = '/opt',
  Boolean $manage_user                                        = true,
  String $user                                                = 'wildfly',
  Stdlib::Unixpath $user_home                                 = '/home/wildfly',
  String $java_xmx                                            = '512m',
  String $java_xms                                            = '256m',
  String $java_maxpermsize                                    = '128m',
  String $package_ensure                                      = 'present',
  Boolean $service_ensure                                     = true,
  Boolean $service_enable                                     = true,
  Boolean $remote_debug                                       = false,
  Boolean $external_facts                                     = false,
  Integer $remote_debug_port                                  = 8787,
  Integer $startup_wait                                       = 30,
  Integer $shutdown_wait                                      = 30,
  Integer $install_download_timeout                           = 500,
  ) {
  include ::profile::wildfly::install
  }
