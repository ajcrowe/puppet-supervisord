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
  $cfgreload             = undef,
  $retries               = undef,
  $config_file_mode      = '0644'
) {

  include supervisord

  # parameter validation
  if $retries { if !is_integer($retries) { validate_re($retries, '^\d+')}}
  validate_re($config_file_mode, '^0[0-7][0-7][0-7]$')
  if $cfgreload { validate_bool($cfgreload) }

  # Reload default with override
  $_cfgreload = $cfgreload ? {
    undef   => $supervisord::cfgreload_rpcinterface,
    default => $cfgreload
  }

  $conf = "${supervisord::config_include}/rpcinterface_${name}.conf"

  file { $conf:
    ensure  => $ensure,
    owner   => 'root',
    mode    => $config_file_mode,
    content => template('supervisord/conf/rpcinterface.erb'),
  }

  if $_cfgreload {
    File[$conf] {
      notify => Class['supervisord::reload'],
    }
  }

}
