################################################################################
#
#   This module manages MongoDB
#
#   Tested platforms:
#    - Ubuntu 12.04 Precise
#
# == Parameters
#
#   [+present+]
#       (OPTIONAL) (default: true)
#
#       this variable allow to chose if the package should be installed (true) or not (false)
#
#   [+bind_ip+]
#       (OPTIONAL) (default: 127.0.0.1)
#
#       Set this option to configure the mongod process to bind to and listen for connections from applications on this address.
#       You may attach mongod instances to any interface; however, if you attach the process to a publicly accessible interface,
#       implement proper authentication or firewall restrictions to protect the integrity of your database.
#       You may concatenate a list of comma separated values to bind mongod to multiple IP addresses (ex: 127.0.0.1,192.168.0.120).
#
#   [+bind_port+]
#       (OPTIONAL) (default: 27017)
#
#       Set this option to configure the mongod port for database instances. MongoDB can bind to any port.
#       You can also filter access based on port using network filtering tools..
#
#   [+security+]
#       (OPTIONAL) (default: false)
#
#       Set to true to enable database authentication for users connecting from remote hosts.
#       Configure users via the mongo shell.
#       If no users exist, the localhost interface will continue to have access to the database until the you create the first user.
#
#   [+db_directory_path+]
#       (OPTIONAL) (default: /var/lib/mongodb)
#
#       Set this option to configure where mongod will store its databases (ex: /srv/mongodb).
#
#   [+log_directory_path+]
#       (OPTIONAL) (default: /var/log/mongodb)
#
#       Set this option to configure where mongod will store its log files.
#
# == Examples
#
#     class {"mongodb" : 
#       present => true,
#       db_directory_path => "/srv/mongodb"
#     }
#
################################################################################
class mongodb (
  $present            = true,
  $bind_ip            = "127.0.0.1",
  $bind_port          = "27017",
  $security           = false,
  $db_directory_path  = "/var/lib/mongodb",
  $log_directory_path = "/var/log/mongodb",
  ) {

  include mongodb::params, mongodb::install, mongodb::config, mongodb::service

}
