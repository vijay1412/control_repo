node 'master.puppet.vm'{
  include role::master_server
}

node /^web/ {
include role::app_server
include role::Wildfly
}
node /^db/ {
include role::db_server
}
