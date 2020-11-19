node 'master.puppet.vm'{
  include role::master_server
}

node /^web/ {
include role::app_server
}
node 'wildflytest.puppet.vm' {
include role::wildfly_server
}
node /^db/ {
include role::db_server
}
