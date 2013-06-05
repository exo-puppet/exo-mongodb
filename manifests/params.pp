class mongodb::params {
  case $::operatingsystem {
    /(Ubuntu)/: {
            $service_name       = "mongodb"
    }
    default: {
      fail ("The ${module_name} module is not supported on $::operatingsystem")
    }
  }
}