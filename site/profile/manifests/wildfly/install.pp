class wildfly::install  {
  
    $install_source = $profile::wildfly::install_source
    $install_file = basename($install_source)

    file { "${wildfly::install_cache_dir}/${install_file}":
      source => $install_source,
}
    # Gunzip+Untar wildfly.tar.gz if download was successful.
     #exec { "untar ${install_file}":
      #command  => "tar --no-same-owner --no-same-permissions --strip-components=1 -C ${wildfly::dirname} -zxvf ${wildfly::install_cache_dir}/${install_file}",
      #path     => ['/bin', '/usr/bin', '/sbin']

 

