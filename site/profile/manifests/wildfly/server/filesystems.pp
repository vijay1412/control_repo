###############################################################################
# PROFILE TO MANAGE LOGICAL VOLUME CONFIGURATIONS FOR TOMCAT
###############################################################################

#
# Reference:
#   https://forge.puppet.com/puppetlabs/lvm
# Dependencies:
#   mod 'puppetlabs-lvm', '1.0.1'
#

class profile::wildfly::server::filesystems(

  # User and Group that owns the filesystems
  # These do not have defaults and MUST be defined by the caller
  $tomcat_user = wildfly
  $tomcat_group =wildfly

  # Mount points
  # These do not have defaults and MUST be defined by the caller
  Stdlib::Absolutepath $catalina_home_mount_point,
  Stdlib::Absolutepath $catalina_base_mount_point,
  Stdlib::Absolutepath $deployedapps_mount_point,
  Stdlib::Absolutepath $server_logs_mount_point,
  Stdlib::Absolutepath $app_logs_mount_point,

  # Volume sizes (with defaults)
  $catalina_home_size = '5G',
  $catalina_base_size = '5G',
  $deployedapps_size = '5G',
  $server_logs_size = '5G',
  $app_logs_size = '5G',

  # Logical Volume Group where volumes are created
  $volume_group = lookup('non_system_volume_group'),
) {

  # Filesystem type
  #   This matches whatever '/' uses
  # $fs_type = undef
  if $facts['virtual'] != 'docker' {
    # Filesystem type
    #   This matches whatever '/' uses
    #   Changed to /boot as newer puppet agents store rootfs as the fileystem type of the '/' mount which
    #   causes issues
    $fs_type = $facts['mountpoints']['/boot']['filesystem']
  }


  #
  # Typical process is:
  # 1. Create Logical Volume
  # 2. Create Filesystem
  # 3. Create directory where filesystem is mounted
  # 4. Mount filesystem to directory
  #

  # ---------------------------------------------------------------------------
  # CATALINA_HOME
  # ---------------------------------------------------------------------------

  $catalina_home_volume_name = 'catalinahome'
  $catalina_home_filesystem = "/dev/${volume_group}/${catalina_home_volume_name}"

  if $facts['virtual'] == 'docker' {
    file { $catalina_home_mount_point:
      ensure => directory,
      owner  => $tomcat_user,
      group  => $tomcat_group,
      mode   => '0755',
      backup => false,
    }
  }
  else {
    logical_volume { $catalina_home_volume_name:
      ensure       => present,
      volume_group => $volume_group,
      size         => $catalina_home_size,
    }

    exec { "mkdir_${catalina_home_mount_point}":
      command => "mkdir ${catalina_home_mount_point}",
      unless  => "test -d ${catalina_home_mount_point}",
      path    => '/usr/bin:/usr/sbin:/bin',
      before  => Mount[$catalina_home_mount_point],
    }

    filesystem { $catalina_home_filesystem:
      ensure  => present,
      fs_type => $fs_type,
      require => Logical_volume[$catalina_home_volume_name],
    }

    mount { $catalina_home_mount_point:
      ensure   => mounted,
      atboot   => true,
      device   => $catalina_home_filesystem,
      fstype   => $fs_type,
      options  => 'defaults,noatime',
      pass     => 2,
      remounts => true,
      require  => Filesystem[$catalina_home_filesystem],
    }

    file { $catalina_home_mount_point:
      ensure  => directory,
      owner   => $tomcat_user,
      group   => $tomcat_group,
      mode    => '0755',
      backup  => false,
      require => Mount[$catalina_home_mount_point],
    }
  }

  # ---------------------------------------------------------------------------
  # CATALINA_BASE
  # ---------------------------------------------------------------------------

  $catalina_base_volume_name = 'catalinabase'
  $catalina_base_filesystem = "/dev/${volume_group}/${catalina_base_volume_name}"

  if $facts['virtual'] == 'docker' {
    file { $catalina_base_mount_point:
      ensure => directory,
      owner  => $tomcat_user,
      group  => $tomcat_group,
      mode   => '0755',
      backup => false,
    }
  }
  else {

    logical_volume { $catalina_base_volume_name:
      ensure       => present,
      volume_group => $volume_group,
      size         => $catalina_home_size,
    }

    filesystem { $catalina_base_filesystem:
      ensure  => present,
      fs_type => $fs_type,
      require => Logical_volume[$catalina_base_volume_name],
    }

    exec { "mkdir_${catalina_base_mount_point}":
      command => "mkdir ${catalina_base_mount_point}",
      unless  => "test -d ${catalina_base_mount_point}",
      path    => '/usr/bin:/usr/sbin:/bin',
      before  => Mount[$catalina_base_mount_point],
    }

    mount { $catalina_base_mount_point:
      ensure   => mounted,
      atboot   => true,
      device   => $catalina_base_filesystem,
      fstype   => $fs_type,
      options  => 'defaults,noatime',
      pass     => 2,
      remounts => true,
      require  => Filesystem[$catalina_base_filesystem],
    }

    file { $catalina_base_mount_point:
      ensure  => directory,
      owner   => $tomcat_user,
      group   => $tomcat_group,
      mode    => '0755',
      backup  => false,
      require => Mount[$catalina_base_mount_point],
    }
  }

  # ---------------------------------------------------------------------------
  # DEPLOYED APPS
  # ---------------------------------------------------------------------------

  $deployedapps_volume_name = 'tomcatdeployedapps'
  $deployedapps_filesystem = "/dev/${volume_group}/${deployedapps_volume_name}"

  if $facts['virtual'] == 'docker' {
    file { $deployedapps_mount_point:
      ensure => directory,
      owner  => $tomcat_user,
      group  => $tomcat_group,
      mode   => '0755',
      backup => false,
    }
  }
  else {

    logical_volume { $deployedapps_volume_name:
      ensure       => present,
      volume_group => $volume_group,
      size         => $deployedapps_size,
    }

    filesystem { $deployedapps_filesystem:
      ensure  => present,
      fs_type => $fs_type,
      require => Logical_volume[$deployedapps_volume_name],
    }

    exec { "mkdir_${deployedapps_mount_point}":
      command => "mkdir ${deployedapps_mount_point}",
      unless  => "test -d ${deployedapps_mount_point}",
      path    => '/usr/bin:/usr/sbin:/bin',
      before  => Mount[$deployedapps_mount_point],
    }

    mount { $deployedapps_mount_point:
      ensure   => mounted,
      atboot   => true,
      device   => $deployedapps_filesystem,
      fstype   => $fs_type,
      options  => 'defaults,noatime',
      pass     => 2,
      remounts => true,
      require  => Filesystem[$deployedapps_filesystem],
    }

    file { $deployedapps_mount_point:
      ensure  => directory,
      owner   => $tomcat_user,
      group   => $tomcat_group,
      mode    => '0755',
      backup  => false,
      require => Mount[$deployedapps_mount_point],
    }
  }

  # ---------------------------------------------------------------------------
  # SERVER LOGS
  # ---------------------------------------------------------------------------

  $server_logs_volume_name = 'tomcatserverlogs'
  $server_logs_filesystem = "/dev/${volume_group}/${server_logs_volume_name}"

  if $facts['virtual'] == 'docker' {
    file { $server_logs_mount_point:
      ensure => directory,
      owner  => $tomcat_user,
      group  => $tomcat_group,
      mode   => '0755',
      backup => false,
    }
  }
  else {

    logical_volume { $server_logs_volume_name:
      ensure       => present,
      volume_group => $volume_group,
      size         => $server_logs_size,
    }

    filesystem { $server_logs_filesystem:
      ensure  => present,
      fs_type => $fs_type,
      require => Logical_volume[$server_logs_volume_name],
    }

    exec { "mkdir_${server_logs_mount_point}":
      command => "mkdir ${server_logs_mount_point}",
      unless  => "test -d ${server_logs_mount_point}",
      path    => '/usr/bin:/usr/sbin:/bin',
      before  => Mount[$server_logs_mount_point],
    }

    mount { $server_logs_mount_point:
      ensure   => mounted,
      atboot   => true,
      device   => $server_logs_filesystem,
      fstype   => $fs_type,
      options  => 'defaults,noatime',
      pass     => 2,
      remounts => true,
      require  => Filesystem[$server_logs_filesystem],
    }

    file { $server_logs_mount_point:
      ensure  => directory,
      owner   => $tomcat_user,
      group   => $tomcat_group,
      mode    => '0755',
      backup  => false,
      require => Mount[$server_logs_mount_point],
    }
  }

  # ---------------------------------------------------------------------------
  # APPLICATION LOGS
  # ---------------------------------------------------------------------------

  $app_logs_volume_name = 'tomcatapplogs'
  $app_logs_filesystem = "/dev/${volume_group}/${app_logs_volume_name}"

  if $facts['virtual'] == 'docker' {
    file { $app_logs_mount_point:
      ensure => directory,
      owner  => $tomcat_user,
      group  => $tomcat_group,
      mode   => '0755',
      backup => false,
    }
  }
  else {

    logical_volume { $app_logs_volume_name:
      ensure       => present,
      volume_group => $volume_group,
      size         => $app_logs_size,
    }

    filesystem { $app_logs_filesystem:
      ensure  => present,
      fs_type => $fs_type,
      require => Logical_volume[$app_logs_volume_name],
    }

    exec { "mkdir_${app_logs_mount_point}":
      command => "mkdir ${app_logs_mount_point}",
      unless  => "test -d ${app_logs_mount_point}",
      path    => '/usr/bin:/usr/sbin:/bin',
      before  => Mount[$app_logs_mount_point],
    }

    mount { $app_logs_mount_point:
      ensure   => mounted,
      atboot   => true,
      device   => $app_logs_filesystem,
      fstype   => $fs_type,
      options  => 'defaults,noatime',
      pass     => 2,
      remounts => true,
      require  => Filesystem[$app_logs_filesystem],
    }

    file { $app_logs_mount_point:
      ensure  => directory,
      owner   => $tomcat_user,
      group   => $tomcat_group,
      mode    => '0755',
      backup  => false,
      require => Mount[$app_logs_mount_point],
    }
  }
}

###############################################################################
