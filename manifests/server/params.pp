class dns::server::params {
  case $::osfamily {
     'Debian': {
       $cfg_dir            = '/etc/bind'
       $cfg_file           = '/etc/bind/named.conf'
       $bind_dir           = '/etc/bind'
       $group              = 'bind'
       $owner              = 'bind'
       $package            = 'bind9'
       $service            = 'bind9'
       $necessary_packages = [ 'bind9', 'dnssec-tools']
       $necessary_files    = File['/etc/bind']
     }
    'RedHat': {
       $cfg_dir            = '/etc/named'
       $cfg_file           = '/etc/named.conf'
       $bind_dir           = '/etc/named'
       $group              = 'named'
       $owner              = 'named'
       $package            = 'named'
       $service            = 'named'
       $necessary_packages = [ 'bind', 'dnssec-tools']
       $necessary_files    = File['/etc/named']
                              
    }
    default: { 
      fail("dns::server is incompatible with this osfamily: ${::osfamily}")
    }
  }
}
