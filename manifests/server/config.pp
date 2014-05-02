class dns::server::config (
  $cfg_dir         = $dns::server::params::cfg_dir,
  $cfg_file        = $dns::server::params::cfg_file,
  $necessary_files = $dns::server::params::necessary_files,
  $owner           = $dns::server::params::owner,
  $group           = $dns::server::params::group,
) inherits dns::server::params {

  file { $cfg_dir:
    ensure => directory,
    owner  => $owner,
    group  => $group,
    mode   => '0755',
  }

  file { "${cfg_dir}/zones":
    ensure => directory,
    owner  => $owner,
    group  => $group,
    mode   => '0755',
  }

  file { "${cfg_dir}/bind.keys.d/":
    ensure => directory,
    owner  => $owner,
    group  => $group,
    mode   => '0755',
  }

  case $::osfamily {
  'Debian': {
   file { "${cfg_file}":
    ensure  => present,
    owner   => $owner,
    group   => $group,
    mode    => '0644',
    require => [
      $necessary_files,
      Class['dns::server::install']
    ],
    notify  => Class['dns::server::service'],
  }
  concat { "${cfg_dir}/named.conf.local":
    owner   => $owner,
    group   => $group,
    mode    => '0644',
    require => Class['concat::setup'],
    notify  => Class['dns::server::service']
  }

  concat::fragment{'named.conf.local.header':
    ensure  => present,
    target  => "${cfg_dir}/named.conf.local",
    order   => 1,
    content => "// File managed by Puppet.\n"
  }
 }
 'RedHat': {
   concat { "${cfg_file}":
    owner   => $owner,
    group   => $group,
    mode    => '0644',
    #require => Class['concat::setup'],
    notify  => Class['dns::server::service']
  }
  }
 }
}
