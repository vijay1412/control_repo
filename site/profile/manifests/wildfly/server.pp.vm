############################################################################################################################################
# Redhat Wilfly Application Server Profile
############################################################################################################################################
class profile::wildfly::server (
  #Define Paths
  Stdlib::Unixpath $wildfly_home_dir                          = '/opt/wildfly',
  Stdlib::Unixpath $console_log                               = '/var/log/wildfly/console.log',
  Stdlib::Unixpath $install_cache_dir                         = '/var/cache/wget',
  Stdlib::Unixpath $deploy_cache_dir                          = '/opt',
  Stdlib::Unixpath $wildfly_logs_base                         = '/var/log/wildfly',
  Stdlib::Unixpath $user_home                                 = '/home/wildfly',
  Stdlib::Absolutepath $server_logs_dir                       = "${wildfly_log_base}/instances",
  $version                                                    = '14.0.1'
  $wildfly_install_bundle                                     = 'wildfly-14.0.1.Final.tar.gz',
  $manage_user                                                = true,
  $user                                                       = 'wildfly',

  # Logical Volume Group where volumes are created
  $volume_group = lookup('non_system_volume_group'),

  # Volume sizes (with defaults)
  $wildfly_home__size = '5G',
  $server_logs_size = '5G',

  # Wildfly home
  $wildfly_home_volume_name   = 'wildflyhome',
  $wildfly_home_filesystem    = "/dev/${volume_group}/${wildfly_home_volume_name}",
  $wildfly_home               = "${wildfly_home_dir}/wildfly-${version}",

  # Server logs
  $server_logs_volume_name    = 'wildflyserverlogs',
  $server_logs_filesystem     = "/dev/${volume_group}/${server_logs_volume_name}",
  $server_logs_path           = "${server_logs_dir}/${::hostname}",
  $server_logs_age            = '30d',


  #Define heap sizes and metaspace

  $java_xmx = '512m',
  $java_xms = '256m',
  $java_maxpermsize = '128m',

  # Java home. Different for both oracle and openJDK
  # OpenJDK by DEFAULT. Overwrite with application hiera.
  $jdk_type = 'openjdk',
  $jdk_version = '1.8.0',



  # Artifactory data coming from hiera
  $artifactory_user     = lookup('artifactory_user'),
  $artifactory_apikey   = lookup('artifactory_apikey'),
  $artifactory_base_url = lookup('artifactory_binary_cache_base_url'),
) {
  require ::profile::users::jbo101
  include ::profile::apache::reverse_proxy
  include ::profile::vas::users_allow::webteam
  include ::profile::amfam_certwildcard::install
  include ::profile::amfam_certca::install

  contain ::profile::wildfly::server::filesystems
  contain ::profile::wildfly::server::install
  Class['profile::wildfly::server::filesystems']
  -> Class['profile::wildfly::server::install']
}
                                                                                                                                               1,1 Top

