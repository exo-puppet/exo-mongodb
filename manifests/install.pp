class mongodb::install {
  case $::operatingsystem {
    /(Ubuntu)/ : {
      repo::define { 'mongodb-10gen-repo':
        file_name    => 'mongodb-10gen',
        url          => $mongodb::version ? {
          $mongodb::params::version_label_24 => $mongodb::params::repo_url_24,
          $mongodb::params::version_label_26 => $mongodb::params::repo_url_26,
          $mongodb::params::version_label_30 => $mongodb::params::repo_url_30,
          default => fail("The specified MongoDB version is not managed (${mongodb::version})")
        },
        distribution => $mongodb::version ? {
          $mongodb::params::version_label_24 => $mongodb::params::repo_dist_24,
          $mongodb::params::version_label_26 => $mongodb::params::repo_dist_26,
          $mongodb::params::version_label_30 => $mongodb::params::repo_dist_30,
          default => fail("The specified MongoDB version is not managed (${mongodb::version})")
        },
        sections     => $mongodb::version ? {
          $mongodb::params::version_label_24 => $mongodb::params::repo_sections_24,
          $mongodb::params::version_label_26 => $mongodb::params::repo_sections_26,
          $mongodb::params::version_label_30 => $mongodb::params::repo_sections_30,
          default => fail("The specified MongoDB version is not managed (${mongodb::version})")
        },
        source       => false,
        key          => '7F0CEB10',
        key_server   => 'keyserver.ubuntu.com',
        notify       => Exec['repo-update'],
      }

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
          Repo::Define['mongodb-10gen-repo'],
          Exec['repo-update']],
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
