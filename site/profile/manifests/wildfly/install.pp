# Downloads and installs Wildfly from a remote source or a system package.
class profile::wildfly::install(
){
    $install_source = $wildfly::install_source
    $install_file = basename($install_source)

    file { "${wildfly::install_cache_dir}/${install_file}":
      source => $install_source,

    # Gunzip+Untar wildfly.tar.gz if download was successful.
      exec { "untar :
      command  => "tar --no-same-owner --no-same-permissions --strip-components=1 -C ${wildfly::dirname} -zxvf ${wildfly::install_cache_dir}/${install_file}",
      path     => ['/bin', '/usr/bin', '/sbin']
      }
    

