class profile::wildfly::server::services(
){
class {'wildfly':
conf_file      => '/etc/default/wildfly.conf'
conf_template  => 'wildfly/wildfly.sysvinit.conf.epp',
    }
    }
