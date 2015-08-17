################################################################################
#
#   This module install MongoDB shell only
#
#   Tested platforms:
#    - Ubuntu 14.04 Trusty Tahr
#
# == Parameters
#
#   [+present+]
#       (OPTIONAL) (default: true)
#
#       this variable allow to chose if the package should be installed (true) or not (false)
#
#   [+version+]
#       (MANDATORY) (default: NOTHING)
#
#       The MongoDB version to use for the installation:
#         - 2.4
#         - 2.6
#         - 3.0
#
# == Examples
#
#     class {"mongodb::shell" :
#       present                 => true,
#       version                 => '2.6',
#     }
#
################################################################################
class mongodb::shell (
  $present = true,
  $version,) inherits mongodb::params {
  case $::operatingsystem {
    /(Ubuntu)/ : {
      class { 'mongodb::install_repo': version=> $version}

      # If MongoDB > 2.4 we need to ensure the old 2.4 package is removed before installing the new one
      # because 2.4 version use another package name
      if ($mongodb::shell::version != $mongodb::params::version_label_24) {
        package { 'mongodb-shell-24':
          ensure => absent,
          name   => $mongodb::params::package_name_client_24,
        }
      }

      package { 'mongodb-shell':
        ensure  => $mongodb::shell::present ? {
          true    => present,
          default => purged,
        },
        name    => $mongodb::shell::version ? {
          $mongodb::params::version_label_24 => $mongodb::params::package_name_client_24,
          $mongodb::params::version_label_26 => $mongodb::params::package_name_client_26,
          $mongodb::params::version_label_30 => $mongodb::params::package_name_client_30,
          default => fail("The specified MongoDB version is not managed (${mongodb::version})")
        },
        require => [
          Repo::Define['mongodb-10gen-repo'],
          Exec['repo-update']],
      }

    }
    default    : {
      fail("The ${module_name} module is not supported on ${::operatingsystem}")
    }
  }
}
