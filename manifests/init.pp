################################################################################
#
#   This module manages MongoDB
#
#   Tested platforms:
#    - Ubuntu 14.04 Trusty Tahr
#    - Ubuntu 12.04 Precise
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
#   [+bind_ip+]
#       (OPTIONAL) (default: 127.0.0.1)
#
#       Set this option to configure the mongod process to bind to and listen for connections from applications on this address.
#       You may attach mongod instances to any interface; however, if you attach the process to a publicly accessible interface,
#       implement proper authentication or firewall restrictions to protect the integrity of your database.
#       You may concatenate a list of comma separated values to bind mongod to multiple IP addresses (ex: 127.0.0.1,192.168.0.120).
#
#   [+storage_engine+] (starting from mongo 3.0+)
#       (OPTIONAL) (default: mmapv1)
#
#       Set this option to configure the storage engine to use (mmapv1 or wiredTiger)
#
#   [+storage_mmapv1_nsSize+]
#       (OPTIONAL) (default: 16)
#
#       Specifies the default size for namespace files, which are files that end in .ns. Each collection and index counts as a namespace.
#       Use this setting to control size for newly created namespace files. This option has no impact on existing files.
#       The maximum size for a namespace file is 2047 megabytes. The default value of 16 megabytes provides for approximately 24,000 namespaces.
#
#   [+log_directory_path+]
#       (OPTIONAL) (default: /var/log/mongodb)
#
#       Set this option to configure where mongod will store its log files.
#
# == Examples
#
#     class {"mongodb" :
#       present                 => true,
#       version                 => '2.6',
#       storage_mmapv1_nsSize   => 64,
#       db_directory_path       => "/srv/mongodb"
#     }
#
################################################################################
class mongodb (
  $present                = true,
  $version,
  $bind_ip                = '127.0.0.1',
  $bind_port              = '27017',
  $security               = false,
  $storage_engine         = 'mmapv1',
  $storage_mmapv1_nsSize  = '16',
  $db_directory_path      = '/var/lib/mongodb',
  $log_directory_path     = '/var/log/mongodb',) inherits mongodb::params {

  # parameters validation
  if ($storage_engine != 'mmapv1') and ($storage_engine != 'wiredTiger') {
    fail('storage_engine parameter must be mmapv1 or wiredTiger')
  }

  include mongodb::params, mongodb::install, mongodb::config, mongodb::service

}
