class mongodb::params {
  case $::operatingsystem {
    /(Ubuntu)/ : {
      # For MongoDB 2.4 and before
      $service_name_24    = 'mongodb'
      $package_name_24 = 'mongodb-10gen'
      $template_config_24 = 'mongodb/etc/mongodb.conf-10gen.erb'
      $config_file_24     = '/etc/mongodb.conf'

      # For MongoDB 2.6 and after
      $service_name_26    = 'mongod'
      $package_name_26 = 'mongodb-org'
      $template_config_26 = 'mongodb/etc/mongodb.conf-org.erb'
      $config_file_26     = '/etc/mongod.conf'

      $logrotate_file  = '/etc/logrotate.d/mongodb'

      $user            = 'mongodb'
      $group           = 'mongodb'

    }
    default    : {
      fail("The ${module_name} module is not supported on ${::operatingsystem}")
    }
  }
}
