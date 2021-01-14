          owner   => $profile::users::jbo101::user,
      group   => $profile::groups::jas::group,
      mode    => '0755',
      backup  => false,
      require => Mount[$profile::wildfly::server::wildfly_home_dir],
    }

logical_volume { $profile::wildfly::server::server_logs_volume_name:
      ensure       => present,
      volume_group => $profile::wildfly::server::volume_group,
      size         => $profile::wildfly::server::server_logs_size,
    }

    filesystem { $profile::wildfly::server::server_logs_filesystem:
      ensure  => present,
      fs_type => $fs_type,
      require => Logical_volume[$profile::wildfly::server::server_logs_volume_name],
    }

    exec { "mkdir_${profile::wildfly::server::server_logs_dir}":
      command => "mkdir ${profile::wildfly::server::server_logs_dir}",
      unless  => "test -d ${profile::wildfly::server::server_logs_dir}",
      path    => '/usr/bin:/usr/sbin:/bin',
      before  => Mount[$profile::wildfly::server::server_logs_dir],
      require => [
        File[
          $profile::wildfly::server::wildfly_log_base,
        ],
      ],
    }

    mount { $profile::wildfly::server::server_logs_dir:
      ensure   => mounted,
      atboot   => true,
      device   => $profile::wildfly::server::server_logs_filesystem,
      fstype   => $fs_type,
      options  => 'defaults,noatime',
      pass     => 2,
      remounts => true,
      require  => Filesystem[$profile::wildfly::server::server_logs_filesystem],
    }

    file { $profile::wildfly::server::server_logs_dir:
      ensure  => directory,
      owner   => $profile::users::jbo101::user,
      group   => $profile::groups::jas::group,
      mode    => '0755',
      backup  => false,
      require => Mount[$profile::wildfly::server::server_logs_dir],
       }
  }
}
