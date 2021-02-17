class role::wildfly_server {
include profile::wildfly::server

wildfly::deployment { 'counter.war':
  source => '/tmp/counter.war'
}

}
