############################################################################################################################################
# PROFILE TO MANAGE Tomcat Apache Kernel Settings
############################################################################################################################################
class profile::wildfly::server::kernel(
  $vm_swappiness = '10',
  $vm_min_free_kbytes = '67584',
) {

  exec { 'tomcat-sysctl-refresh':
    command     => '/sbin/sysctl --system',
    subscribe   => [
      File['/etc/sysctl.d/90-tomcat.conf'],
    ],
    refreshonly => true,
  }

  # Set kernel settings for app
  file { '/etc/sysctl.d/90-tomcat.conf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('profile/apache/tomcat/sysctl/90-tomcat.conf.epp'),
  }

}

