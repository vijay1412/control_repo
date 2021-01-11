 file { '/etc/default/wildfly.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('profile/wildfly/server/'),
    notify  => Exec['Systemd-Daemon-Reload-Exec'],
