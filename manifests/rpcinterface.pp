# Define: supervisord::rpcinterface
#
# This define creates an rpcinterface configuration file
#
# Documentation on parameters available at:
# http://supervisord.org/configuration.html#rpcinterface-x-section-settings
#
# @param rpcinterface_factory
# @param ensure
# @param retries
# @param config_file_mode
#
define supervisord::rpcinterface (
  Optional[String] $rpcinterface_factory = undef,
  String $ensure                         = 'present',
  Optional[Integer] $retries             = undef,
  String $config_file_mode               = '0644',
) {
  include supervisord

  $conf = "${supervisord::config_include}/rpcinterface_${name}.conf"

  file { $conf:
    ensure  => $ensure,
    owner   => 'root',
    mode    => $config_file_mode,
    content => template('supervisord/conf/rpcinterface.erb'),
    notify  => Class['supervisord::reload'],
  }
}
