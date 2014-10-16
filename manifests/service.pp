class mongodb::service {
  require mongodb::config

  service { 'mongodb':
    ensure     => running,
    name       => $mongodb::package_name ? {
      $mongodb::params::package_name_24 => $mongodb::params::service_name_24,
      $mongodb::params::package_name_26 => $mongodb::params::service_name_26,
      default => fail("The specified MongoDB package name is not managed (${mongodb::package_name})")
    },
    hasstatus  => true,
    hasrestart => true,
    require    => Class['mongodb::config'],
  }
}

