####
# Manage MongoDB MMS Agent installation
#
class mongodb::mms::agent (
  $ensure  = 'started',
  $api_key = false,
  $version = '3.1.0.175-1_amd64',
  $download_directory) {
  # parameters validation
  if ($ensure != 'started') and ($ensure != 'absent') and ($ensure != 'stopped') {
    fail('[ensure] parameter must on of the following values : [ started | absent | stopped]')
  }

  if ($ensure == 'started') and (($api_key == false) or ($api_key == true) or ($api_key == '')) {
    fail('the [api_key] parameter must contain a valid MMS Api Key when the agent is enabled (ensure=started)')
  }

  $target_filename = "mongodb-mms-monitoring-agent_${mongodb::mms::agent::version}.deb"
  wget::fetch { 'fetch-mongodb-mms-monitoring-agent.deb':
    source_url       => "https://mms.mongodb.com/download/agent/monitoring/mongodb-mms-monitoring-agent_${mongodb::mms::agent::version}.deb",
    target_directory => $download_directory,
    target_file      => $target_filename
  } ->
  package { 'mongodb-mms-monitoring-agent':
    ensure   => $mongodb::mms::agent::ensure ? {
      'stopped' => 'present',
      'absent'  => 'absent',
      default   => 'latest'
    },
    source   => "${download_directory}/${target_filename}",
    provider => 'dpkg',
  } ->
  file { '/etc/mongodb-mms/monitoring-agent.config':
    ensure  => $mongodb::mms::agent::ensure ? {
      'absent' => 'absent',
      default  => 'file'
    },
    owner   => 'root',
    group   => 'mongodb-mms-agent',
    mode    => '0640',
    content => template('mongodb/etc/mongodb-mms/monitoring-agent.config.erb'),
    notify  => Service['mongodb-mms-monitoring-agent'],
    require => Package['mongodb-mms-monitoring-agent'],
  } ->
  service { 'mongodb-mms-monitoring-agent':
    ensure  => $mongodb::mms::agent::ensure ? {
      'started' => 'running',
      default   => 'stopped'
    },
    require => Package['mongodb-mms-monitoring-agent'],
  }
}
