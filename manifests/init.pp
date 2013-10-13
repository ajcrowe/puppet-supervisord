# This class installs supervisord and configured it to run on boot
class supervisord(
  $package_ensure       = $supervisord::params::package_ensure,
  $install_init         = false,
  $install_pip          = false,
  $setuptools_url       = $supervisord::params::setuptools_url,

  $logpath              = $supervisord::params::logpath,
  $logfile              = $supervisord::params::logfile,
  $logfile_maxbytes     = $supervisord::params::logfile_maxbytes,
  $logfile_backups      = $supervisord::params::logfile_backups,
  $log_level            = $supervisord::params::log_level,

  $runpath              = $supervisord::params::runpath,
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

  if $install_pip {
    include supervisord::pip
    Class['supervisord::pip'] -> Class['supervisord::install']
  }
  include supervisord::install supervisord::config

  Class['supervisord::install'] -> Class['supervisord::config'] ~> Config['supervisord::service']
}
