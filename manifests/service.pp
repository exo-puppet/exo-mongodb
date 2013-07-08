class mongodb::service {
  require mongodb::config

  service { 'mongodb':
    ensure     => running,
    name       => $mongodb::params::service_name,
    hasstatus  => true,
    hasrestart => true,
    require    => Class['mongodb::config'],
  }
}

