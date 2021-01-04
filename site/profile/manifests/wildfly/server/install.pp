class profile::wildfly::server::install {
class { 'wildfly':
  version        => '14.0.0',
  install_source => 'http://download.jboss.org/wildfly/14.0.0.Final/wildfly-14.0.0.Final.tar.gz',
  java_opts      => '-Djava.net.preferIPv4Stack=true'
}
wildfly::web::connector { 'https':
  scheme         => 'https',
  protocol       => 'HTTP/1.1',
  socket_binding => 'https',
  enable_lookups => false,
  secure         => true,
}
->
wildfly::web::ssl { 'ssl':
  connector            => 'https',
  protocol             => 'TLSv1,TLSv1.1,TLSv1.2',
  password             => 'changeit',
  key_alias            => 'demo',
  certificate_key_file => '/opt/identitykeystore.jks',
  cipher_suite         => 'TLS_RSA_WITH_AES_128_CBC_SHA,SSL_RSA_WITH_3DES_EDE_CBC_SHA',
}
}
