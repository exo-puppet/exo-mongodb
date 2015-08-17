################################################################################
#
#   This module install MongoDB package repository
#
#   Tested platforms:
#    - Ubuntu 14.04 Trusty Tahr
#    - Ubuntu 12.04 Precise
#
# == Parameters
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
#     class {"mongodb::install_repo" :
#       version                 => '3.0',
#     }
#
################################################################################
class mongodb::install_repo ($version) {
  case $::operatingsystem {
    /(Ubuntu)/ : {
      repo::define { 'mongodb-10gen-repo':
        file_name    => 'mongodb-10gen',
        url          => $version ? {
          $mongodb::params::version_label_24 => $mongodb::params::repo_url_24,
          $mongodb::params::version_label_26 => $mongodb::params::repo_url_26,
          $mongodb::params::version_label_30 => $mongodb::params::repo_url_30,
          default => fail("The specified MongoDB version is not managed (${version})")
        },
        distribution => $version ? {
          $mongodb::params::version_label_24 => $mongodb::params::repo_dist_24,
          $mongodb::params::version_label_26 => $mongodb::params::repo_dist_26,
          $mongodb::params::version_label_30 => $mongodb::params::repo_dist_30,
          default => fail("The specified MongoDB version is not managed (${version})")
        },
        sections     => $version ? {
          $mongodb::params::version_label_24 => $mongodb::params::repo_sections_24,
          $mongodb::params::version_label_26 => $mongodb::params::repo_sections_26,
          $mongodb::params::version_label_30 => $mongodb::params::repo_sections_30,
          default => fail("The specified MongoDB version is not managed (${version})")
        },
        source       => false,
        key          => '7F0CEB10',
        key_server   => 'keyserver.ubuntu.com',
        notify       => Exec['repo-update'],
      }
    }
    default    : {
      fail("The ${module_name} module is not supported on ${::operatingsystem}")
    }
  }
}
