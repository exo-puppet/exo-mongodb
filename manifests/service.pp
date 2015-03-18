class mongodb::service {
  require mongodb::config

  service { 'mongodb':
    ensure     => running,
    name       => $mongodb::version ? {
      $mongodb::params::version_label_24 => $mongodb::params::service_name_24,
      $mongodb::params::version_label_26 => $mongodb::params::service_name_26,
      $mongodb::params::version_label_30 => $mongodb::params::service_name_30,
      default => fail("The specified MongoDB version is not managed (${mongodb::version})")
    },
    hasstatus  => true,
    hasrestart => true,
    require    => Class['mongodb::config'],
  }
}

