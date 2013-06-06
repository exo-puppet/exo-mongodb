class mongodb::params {
  case $::operatingsystem {
    /(Ubuntu)/ : {
      $service_name   = "mongodb"
      $package_name   = "mongodb-10gen"

      $config_file    ="/etc/mongodb.conf"
      $logrotate_file ="/etc/logrotate.d/mongodb"

      $user           = "mongodb"
      $group          = "mongodb"

    }
    default    : {
      fail("The ${module_name} module is not supported on $::operatingsystem")
    }
  }
}
