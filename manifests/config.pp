class mongodb::config {

  file { '/etc/mongodb.conf':
    content => template('mongodb/etc/mongodb.conf.erb'),
    path    => "${mongodb::params::config_file}",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Service ["mongodb"],
  }
}
