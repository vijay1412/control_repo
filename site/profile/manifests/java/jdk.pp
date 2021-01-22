######################
#jdk
########################
class profile::java::jdk(
  $version  = '1.8.0',
  $type     = 'openjdk',
) {
  case $type {
    'openjdk': {
      case $version {
        '1.6.0', '1.7.0', '1.8.0', '11': {
          $java_home = '/usr/lib/jvm/java'

          class { '::profile::java::jdk::openjdk':
            version   => $version,
            java_home => $java_home,
          }
        }
        default: {
          fail("ERROR: Unsupported openjdk version ${version}")
        }
      }
