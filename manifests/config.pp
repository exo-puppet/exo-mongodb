class mongodb::config {
  file { 'mongodb.conf':
    content => $mongodb::version ? {
      $mongodb::params::version_label_24 => template($mongodb::params::template_config_24),
      $mongodb::params::version_label_26 => template($mongodb::params::template_config_26),
      $mongodb::params::version_label_30 => template($mongodb::params::template_config_30),
      default => fail("The specified MongoDB version is not managed (${mongodb::version})")
    },
    path    => $mongodb::version ? {
      $mongodb::params::version_label_24 => $mongodb::params::config_file_24,
      $mongodb::params::version_label_26 => $mongodb::params::config_file_26,
      $mongodb::params::version_label_30 => $mongodb::params::config_file_30,
      default => fail("The specified MongoDB version is not managed (${mongodb::version})")
    },
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Service['mongodb'],
  }

  if ($mongodb::version == $mongodb::params::version_label_24) {
    # For MongoDB 2.4 => ensure any MongoDB 2.6+ config file is not present
    file { '/etc/mongodb.conf-absent':
      ensure => absent,
      path   => $mongodb::params::config_file_26
    }
  } else {
    # For MongoDB 2.6+ => remove old MongoDB 2.4 config file
    file { '/etc/mongodb.conf-absent':
      ensure => absent,
      path   => $mongodb::params::config_file_24
    }
  }
}
