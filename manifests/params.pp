class mongodb::params {
  case $::operatingsystem {
    /(Ubuntu)/ : {
      # For MongoDB 2.4 and before
      $version_label_24   = '2.4'
      $repo_url_24        = 'http://downloads-distro.mongodb.org/repo/ubuntu-upstart'
      $repo_dist_24       = 'dist'
      $repo_sections_24   = ['10gen']
      $service_name_24    = 'mongodb'
      $package_name_24    = 'mongodb-10gen'
      $template_config_24 = 'mongodb/etc/mongodb.conf_24.erb'
      $config_file_24     = '/etc/mongodb.conf'

      # For MongoDB 2.6
      $version_label_26   = '2.6'
      $repo_url_26        = $repo_url_24
      $repo_dist_26       = $repo_dist_24
      $repo_sections_26   = $repo_sections_24
      $service_name_26    = 'mongod'
      $package_name_26    = 'mongodb-org'
      $template_config_26 = 'mongodb/etc/mongodb.conf_26.erb'
      $config_file_26     = '/etc/mongod.conf'

      # For MongoDB 3.0 and after
      $version_label_30   = '3.0'
      $repo_url_30        = 'http://repo.mongodb.org/apt/ubuntu'
      $repo_dist_30       = "${lsbdistcodename}/mongodb-org/3.0"
      $repo_sections_30   = ['multiverse']
      $service_name_30    = $service_name_26
      $package_name_30    = $package_name_26
      $template_config_30 = 'mongodb/etc/mongodb.conf_30.erb'
      $config_file_30     = $config_file_26

      $logrotate_file     = '/etc/logrotate.d/mongodb'

      $user               = 'mongodb'
      $group              = 'mongodb'

    }
    default    : {
      fail("The ${module_name} module is not supported on ${::operatingsystem}")
    }
  }
}
