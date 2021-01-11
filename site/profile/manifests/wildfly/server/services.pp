class profile::wildfly::server::services(
){
file { '/etc/default/wildfly.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('modules/wildfly/templates/wildfly.sysvinit.conf.epp'),
    }
    }
