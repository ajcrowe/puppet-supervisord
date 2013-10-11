# This class installs supervisord and configured it to run on boot
class supervisord(
  $package_ensure       = $supervisord::params::package_ensure,
  $package_name         = $supervisord::params::package_name,
  $package_provider     = $supervisord::params::package_provider,
  $install_init         = false,

  $logfile              = $supervisord::params::logfile,
  $logfile_maxbytes     = $supervisord::params::logfile_maxbytes,
  $logfile_backups      = $supervisord::params::logfile_backups,
  $log_level            = $supervisord::params::log_level,

  $pidfile              = $supervisord::params::pidfile,
  $nodaemon             = $supervisord::params::nodaemon,
  $minfds               = $supervisord::params::minfds,
  $minprocs             = $supervisord::params::minprocs,
  $configfile           = $supervisord::params::configfile,
  $nodaemon             = $supervisord::params::nodaemon,
  $umask                = $supervisord::params::umask,

  $unix_socket          = $supervisord::params::unix_socket,
  $unix_socket_file     = $supervisord::params::unix_socket_file,
  $unix_socket_mode     = $supervisord::params::unix_socket_mode,
  $unix_socket_owner    = $supervisord::params::unix_socket_owner,
  $unix_scoket_group    = $supervisord::params::unix_socket_group,

  $inet_server          = $supervisord::params::inet_server,
  $inet_server_hostname = $supervisord::params::inet_hostname,
  $inet_server_port     = $supervisord::params::inet_port,

  $unix_auth            = false,
  $unix_username        = undef,
  $unix_password        = undef,

  $inet_auth            = false,  
  $inet_username        = undef,
  $inet_password        = undef,

  $user                 = undef,
  $identifier           = undef,
  $childlogdir          = undef,
  $environment          = undef,
  $strip_ansi           = false,
  $nocleanup            = false

) inherits supervisord::params {

  if package_provider == 'pip' {
    exec { 'easy_install pip':
      command => 'easy_install pip',
      path    => '/sbin:/bin:/usr/sbin:/usr/bin:/root/bin',
      unless  => 'which pip',
      before  => Package['python-setuptools']
    }
    package { 'python-setuptools': ensure => installed }
  }

  package { $package_name:
    ensure   => "$package_ensure",
    provider => "$package_provider"
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

  concat::fragment { 'supervisord_main':
    target  => $configfile,
    content => template('supervisord/supervisord_main.erb'),
    order   => 02
  }
}
