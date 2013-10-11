# This class installs supervisord and configured it to run on boot
class supervisord(
  $package_ensure       = $supervisord::params::package_ensure,
  $package_name         = $supervisord::params::package_name,
  $package_provider     = $supervisord::params::package_provider,

  $unix_socket          = $supervisord::params::unix_socket,
  $unix_socket_file     = $supervisord::params::unix_socket_file,
  $unix_socket_mode     = $supervisord::params::unix_socket_mode,
  $unix_socket_owner    = $supervisord::params::unix_socket_owner,
  $unix_scoket_group    = $supervisord::params::unix_socket_group,

  $unix_auth            = false,
  $unix_username        = undef,
  $unix_password        = undef,

  $inet_server          = $supervisord::params::inet_server,
  $inet_server_hostname = $supervisord::params::inet_hostname,
  $inet_server_port     = $supervisord::params::inet_port,
  $inet_auth            = false,  
  $inet_username        = undef,
  $inet_password        = undef,

  $logfile              = $supervisord::params::logfile,
  $logfile_maxbytes     = $supervisord::params::logfile_maxbytes,
  $logfile_backups      = $supervisord::params::logfile_backups,
  $loglevel             = $supervisord::params::loglevel,

  $pidfile              = $supervisord::params::pidfile,
  $nodaemon             = $supervisord::params::nodaemon,
  $minfds               = $supervisord::params::minfds,
  $minprocs             = $supervisord::params::minprocs,
  $configfile           = $supervisord::params::configfile,
  $nodaemon             = $supervisord::params::nodaemon,

  $user                 = undef,
  $umask                = undef,
  $identifier           = undef,
  $childlogdir          = undef,
  $environment          = undef,
  $strip_ansi           = false,
  $nocleanup            = false,

) inherits supervisord::params {

  if $unix_socket and $inet_server {
    fail('Cannot use both unix_socket or inet_server')
  }
  elsif $unix_socket != true or $inet_server != true {
    fail('Please select either unix_socket or inet_server')
  }

  package { $package_name:
    ensure   => "$package_ensure",
    provider => "$package_provider",
  }
  
  concat { $configfile:
    owner => 'root',
    group => 'root',
    mode  => '0755'
  }

  if $unix_socket {
    concat::fragment { 'supervisord_unix':
      target  => $configfile,
      content => template('supervisord/supervisord_unix.erb'),
      order   => 01
    }
  }
  
  if $inet_socket {
    concat::fragment { 'supervisord_inet':
      target  => $configfile,
      content => template('supervisord/supervisord_inet.erb'),
      order   => 01
    }
  }

  concat::fragment { 'supervisord_main_config':
    target  => $configfile,
    content => template('supervisord/supervisord.conf.erb'),
    order   => 02
  }

}
