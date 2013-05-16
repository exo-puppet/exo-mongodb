################################################################################
#
#   This module manages MongoDB
#
#   Tested platforms:
#    - Ubuntu 12.04 Precise
#
# == Parameters
#
# == Examples
#
#
################################################################################
class mongodb ($present=true) {
  
  include mongodb::params, mongodb::install, mongodb::config, mongodb::service
  
}