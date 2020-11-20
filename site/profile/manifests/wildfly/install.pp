# Downloads and installs Wildfly from a remote source or a system package.
class profile::wildfly::install(
){
    $install_source = $wildfly::install_source
    $install_file = basename($install_source)

    file { "${wildfly::install_cache_dir}/${install_file}":
      source => $install_source,
}

