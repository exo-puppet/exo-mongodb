class mongodb::install {
  case $::operatingsystem {
    /(Ubuntu)/ : {

      class {'mongodb::install_repo': version=> $mongodb::version}

      # If MongoDB > 2.4 we need to ensure the old 2.4 package is removed before installing the new one
      # because 2.4 version use another package name
      if ( $mongodb::version != $mongodb::params::version_label_24 ) {
        package { 'mongodb-24':
          ensure  => absent,
          name    => $mongodb::params::package_name_24,
        }
      }

      package { 'mongodb':
        ensure  => $mongodb::present ? {
          true    => present,
          default => purged,
        },
        name    => $mongodb::version ? {
          $mongodb::params::version_label_24 => $mongodb::params::package_name_24,
          $mongodb::params::version_label_26 => $mongodb::params::package_name_26,
          $mongodb::params::version_label_30 => $mongodb::params::package_name_30,
          default => fail("The specified MongoDB version is not managed (${mongodb::version})")
        },
        require => [
          File['mongodb.conf'],
          Apt::Source['mongodb-10gen'],
          Class['apt::update'],
        ],
      }

    }
    default    : {
      fail("The ${module_name} module is not supported on ${::operatingsystem}")
    }
  }

  # DATA Directory
  file { $mongodb::db_directory_path:
    ensure  => directory,
    owner   => $mongodb::params::user,
    group   => $mongodb::params::group,
    require => Package['mongodb'],
    notify  => Service['mongodb'],
  }

  # logrotate
  file { '/etc/logrotate.d/mongodb':
    ensure  => $mongodb::present ? {
      true    => present,
      default => purged,
    },
    content => template('mongodb/etc/logrotate.d/mongodb.erb'),
    path    => $mongodb::params::logrotate_file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['mongodb'],
  }

}
