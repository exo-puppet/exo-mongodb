class mongodb::install {
  require mongodb::params

  repo::define { "mongodb-10gen-repo":
    file_name    => "mongodb-10gen",
    url          => "http://downloads-distro.mongodb.org/repo/ubuntu-upstart",
    distribution => "dist",
    sections     => ["10gen"],
    source       => false,
    key          => "7F0CEB10",
    key_server   => "keyserver.ubuntu.com",
    notify       => Exec["repo-update"],
  } -> 
  package { "mongodb":
    name    => "mongodb-10gen",
    ensure  => $mongodb::present ? {
      true    => present,
      default => purged,
    },
    require => [Repo::Define["mongodb-10gen-repo"], Exec["repo-update"]],
  }

}