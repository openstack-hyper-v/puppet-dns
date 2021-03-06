define dns::key (
  $cfg_dir = $dns::server::params::cfg_dir,
  $owner   = $dns::server::params::owner,
  $group   = $dns::server::params::group,
  $necessary_packages = $dns::server::params::necessary_packages,
  $necessary_files    = $dns::server::params::necessary_files,
) {

  file { "/tmp/${name}-secret.sh":
    ensure  => file,
    mode    => '0777',
    content => template('dns/secret.erb'),
    notify  => Exec["dnssec-keygen-${name}"],
  }

  exec { "dnssec-keygen-${name}":
    command     => "/usr/sbin/dnssec-keygen -a HMAC-MD5 -r /dev/urandom -b 128 -n USER ${name}",
    cwd         => "${cfg_dir}/bind.keys.d",
    require     => [
       Package[$necessary_packages],
      $necessary_files,
    ],
    refreshonly => true,
    notify      => Exec["get-secret-from-${name}"],
  }

  exec { "get-secret-from-${name}":
    command     => "/tmp/${name}-secret.sh",
    cwd         => "${cfg_dir}/bind.keys.d",
    creates     => "${cfg_dir}/bind.keys.d/${name}.secret",
    require     => [
      Exec["dnssec-keygen-${name}"],
      File["${cfg_dir}/bind.keys.d","/tmp/${name}-secret.sh"]],
  }

  file { "${cfg_dir}/bind.keys.d/${name}.secret":
    require => Exec["get-secret-from-${name}"],
  }

  concat { "${cfg_dir}/bind.keys.d/${name}.key":
    owner   => $owner,
    group   => $group,
    mode    => '0644',
    require => Class['concat::setup'],
    notify  => Class['dns::server::service']
  }

  Concat::Fragment {
    ensure  => present,
    target  => "${cfg_dir}/bind.keys.d/${name}.key",
    require => [
      Exec["get-secret-from-${name}"],
      File["${cfg_dir}/bind.keys.d/${name}.secret"]
    ],
  }

  concat::fragment { "${name}.key-header":
    order   => 1,
    content => template('dns/key.erb'),
  }

  concat::fragment { "${name}.key-secret":
    order   => 2,
    source  => "${cfg_dir}/bind.keys.d/${name}.secret",
  }

  concat::fragment { "${name}.key-footer":
    order   => 3,
    content => '}:',
  }

}
