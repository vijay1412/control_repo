###############################################################################
# PROFILE TO INSTALL AND CONFIGURE OPEN JDK
###############################################################################

class profile::java::jdk::openjdk(
  # Version default
  #  NOTE: to use Version 11, the hiera key needs to be surrounded in quotes or it'll be looked up
  #          as an integer and cause an issue below.
  #             profile::java::jdk::openjdk::version: '11'
  $version = '1.8.0',
  $java_home = '/usr/lib/jvm/java',
) {
  # Derive the java major version
  case $version {
    /^1\.6/: { $version_major = '6' }
    /^1\.7/: { $version_major = '7' }
    /^1\.8/: { $version_major = '8' }
    /^11/: { $version_major = '11' }
    default: { fail("ERROR: Unsupported open JDK version ${version}") }
  }

  # Install JDK (devel) packages, not just jre
  package { "java-${version}-openjdk-devel.x86_64":
    ensure  => installed,
  }
