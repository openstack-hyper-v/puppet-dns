class dns::server {
  include dns::server::install
  include dns::server::config
  include dns::server::service
  if $::osfamily == 'Redhat'{
  	# include dns::server::options
  	dns::server::options{"default":}
  }
}

