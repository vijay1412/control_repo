class profile::wildfly::server::install {
wildfly::resource { "/system-property=myproperty":
  content => {
    'value' => '1234'
  },
}

}
