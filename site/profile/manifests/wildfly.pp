#
# Main class, includes all other classes.
#
# @param config Sets Wildfly configuration file for initialization when you're using 'standalone' mode.
# @param conf_file Sets a file to be used for service configuration.
# @param conf_template Sets a template file for service configuration.
# @param console_log Configures service log file.
# @param custom_init Sets a custom init script.
# @param distribution Sets the Wildfly distribution: 'wildfly' or 'jboss-eap'.
# @param dirname `JBOSS_HOME`. i.e. The directory where your Wildfly will live.
# @param domain_config Sets Wildfly configuration file for initialization when you're using 'domain' mode.
# @param external_facts Whether it should deploy external facts.
# @param gid Sets managed group ID.
# @param group Group to own `JBOSS_HOME`. If `manage_user` is `true`, this group will be managed.
# @param host_config Sets Wildfly Host configuration file for initialization when you're using 'domain' mode.
# @param init_system Sets initsystem for service configuration.
# @param install_cache_dir The directory to be used for wget cache.
# @param deploy_cache_dir The directory to be used for deployment cache.
# @param install_download_timeout Sets the timeout for installer download.
# @param install_source Source of Wildfly tarball installer.
# @param java_home Sets the `JAVA_HOME` for Wildfly.
# @param java_opts Sets `JAVA_OPTS`, allowing to override several Java params, like `Xmx`, `Xms` and `MaxPermSize`,
# @param java_xmx Sets Java's `-Xmx` parameter.
# @param java_xms Sets Java's `-Xms` parameter.
# @param java_maxpermsize Sets Java's `-XX:MaxPermSize` parameter.
#   e.g. `-Xms64m -Xmx512m -XX:MaxPermSize=256m`.
# @param jboss_opts Sets `JBOSS_OPTS`, allowing to override several JBoss properties. It only works with Wildfly 8.2+.
# @param manage_user Whether this module should manage wildfly user and group.
# @param mgmt_user Hash containing a Wildfly's management user to be used internally.
# @param mode Sets Wildfly execution mode will run, 'standalone' or 'domain'.
# @param mode_template Sets epp template for standalone.conf or domain.conf.
# @param overlay_class Sets a class to be applied between 'install' and 'setup' classes.
# @param package_ensure Wheter it should manage required packages.
# @param package_name Sets Wildfly package name.
# @param package_version Sets Wildfly package version.
# @param properties Sets properties for your service.
# @param remote_debug Whether remote debug should be enabled.
# @param remote_debug_port Sets the port to be used by remote debug.
# @param remote_username Sets remote username in host config.
# @param secret_value Sets the secret value in host config.
# @param service_ensure Sets Wildfly's service 'ensure'.
# @param service_enable Sets Wildfly's service 'enable'.
# @param service_file Sets a file to be used for service management.
# @param service_name Sets Wildfly's service 'name'.
# @param service_manage Reload Wildfly's service when changed config.
# @param shutdown_wait Sets the time to wait for the process to be shutdown - sysvinit scripts only.
# @param startup_wait Sets the time to wait for the process to be up - sysvinit scripts only.
# @param systemd_template Sets a custom systemd template.
# @param uid Sets managed user ID.
# @param user User to own `JBOSS_HOME`. If `manage_user` is `true`, this user will be managed.
# @param user_home User home directory. Defaults to '/home/wildfly'
# @param version Sets the Wildfly version managed in order to handle small differences among versions.
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
