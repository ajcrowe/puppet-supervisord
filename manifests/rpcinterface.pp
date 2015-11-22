# Define: supervisord::rpcinterface
#
# This define creates an rpcinterface configuration file
#
# Documentation on parameters available at:
# http://supervisord.org/configuration.html#rpcinterface-x-section-settings
#
define supervisord::rpcinterface (
  $rpcinterface_factory,
  $ensure                = present,
  $retries               = undef,
) {

  include supervisord

  # parameter validation
  if $retries { if !is_integer($retries) { validate_re($retries, '^\d+')}}

  $conf = "${supervisord::config_include}/rpcinterface_${name}.conf"

  file { $conf:
    ensure  => $ensure,
    owner   => 'root',
    mode    => '0644',
    content => template('supervisord/conf/rpcinterface.erb'),
    notify  => Class['supervisord::reload']
  }

}
