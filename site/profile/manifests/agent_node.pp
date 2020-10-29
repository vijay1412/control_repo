class profile::agent{
  include dockeragent 
  dockeragent::node {'web.puppet.vm':}
  dockeragent::node {'db.puppet.vm':}
  }
