class dns::server::params {
  case $::osfamily {
    'Debian': {
      $cfg_dir = '/etc/bind'
      $group   = 'bind'
      $owner   = 'bind'
      $package = 'bind9'
      $service = 'bind9'
      $necessary_packages = [ 'bind9', 'dnssec-tools']
    }
    'RedHat': {
       $cfg_dir = '/etc'
       $group   = 'bind'
       $owner   = 'named'
       $package = 'named'
       $service = 'named'
       $necessary_packages = [ 'bind', 'dnssec-tools']
    }
    default: { 
      fail("dns::server is incompatible with this osfamily: ${::osfamily}")
    }
  }
}
