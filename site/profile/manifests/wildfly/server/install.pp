class profile::wildfly::server::install {
class { 'wildfly':
  version        => '14.0.0',
  install_source => 'http://download.jboss.org/wildfly/14.0.0.Final/wildfly-14.0.0.Final.tar.gz',
}
wildfly::config::module { 'org.postgresql':
  source       => 'http://repo1.maven.org/maven2/org/postgresql/postgresql/9.3-1103-jdbc4/postgresql-9.3-1103-jdbc4.jar',
  dependencies => ['javax.api', 'javax.transaction.api']
}
}

