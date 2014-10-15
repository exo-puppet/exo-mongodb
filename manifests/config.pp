class mongodb::config {
  file { 'mongodb.conf':
    content => $mongodb::package_name ? {
      $mongodb::params::package_name_24 => template($mongodb::params::template_config_24),
      $mongodb::params::package_name_26 => template($mongodb::params::template_config_26),
      default => fail("The specified MongoDB package name is not managed (${mongodb::package_name})")
    },
    path    => $mongodb::package_name ? {
      $mongodb::params::package_name_24 => $mongodb::params::config_file_24,
      $mongodb::params::package_name_26 => $mongodb::params::config_file_26,
      default => fail("The specified MongoDB package name is not managed (${mongodb::package_name})")
    },
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Service['mongodb'],
  }

  if ($mongodb::package_name == $mongodb::params::package_name_24) {
    # For MongoDB 2.4 => ensure any MongoDB 2.6+ config file is not present
    file { '/etc/mongodb.conf-absent':
      ensure => absent,
      path   => $mongodb::params::config_file_26
    }
  } elsif ($mongodb::package_name == $mongodb::params::package_name_26) {
    # For MongoDB 2.6+ => remove old MongoDB 2.4 config file
    file { '/etc/mongodb.conf-absent':
      ensure => absent,
      path   => $mongodb::params::config_file_24
    }
  }
}
