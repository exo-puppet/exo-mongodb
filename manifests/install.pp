class mongodb::install {
  case $::operatingsystem {
    /(Ubuntu)/ : {
      repo::define { 'mongodb-10gen-repo':
        file_name    => 'mongodb-10gen',
        url          => 'http://downloads-distro.mongodb.org/repo/ubuntu-upstart',
        distribution => 'dist',
        sections     => [
          '10gen'],
        source       => false,
        key          => '7F0CEB10',
        key_server   => 'keyserver.ubuntu.com',
        notify       => Exec['repo-update'],
      } -> package { 'mongodb':
        ensure  => $mongodb::present ? {
          true    => present,
          default => purged,
        },
        name    => $mongodb::params::package_name,
        require => [
          File['/etc/mongodb.conf'],
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
