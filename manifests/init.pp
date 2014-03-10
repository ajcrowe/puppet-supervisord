# Class: supervisord
#
# This class installs supervisord via pip
#
class supervisord(
  $package_ensure       = $supervisord::params::package_ensure,
  $service_ensure       = $supervisord::params::service_ensure,
  $install_init         = $supervisord::params::install_init,
  $install_pip          = false,
  $init_defaults        = $supervisord::params::init_defaults,
  $setuptools_url       = $supervisord::params::setuptools_url,
  $executable           = $supervisord::params::executable,

  $log_path             = $supervisord::params::log_path,
  $log_file             = $supervisord::params::log_file,
  $log_level            = $supervisord::params::log_level,
  $logfile_maxbytes     = $supervisord::params::logfile_maxbytes,
  $logfile_backups      = $supervisord::params::logfile_backups,

  $run_path             = $supervisord::params::run_path,
  $pid_file             = $supervisord::params::pid_file,
  $nodaemon             = $supervisord::params::nodaemon,
  $minfds               = $supervisord::params::minfds,
  $minprocs             = $supervisord::params::minprocs,
  $config_include       = $supervisord::params::config_include,
  $config_file          = $supervisord::params::config_file,
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
  $env_var              = undef,
  $strip_ansi           = false,
  $nocleanup            = false

) inherits supervisord::params {

  validate_bool($install_pip)
  validate_bool($install_init)
  validate_bool($nodaemon)
  validate_bool($unix_auth)
  validate_bool($inet_auth)
  validate_bool($strip_ansi)
  validate_bool($nocleanup)

  validate_absolute_path($config_include)
  validate_absolute_path($config_file)

  validate_absolute_path($log_path)
  validate_absolute_path($log_file)

  validate_absolute_path($run_path)
  validate_absolute_path($pid_file)

  if $env_var {
    validate_hash($env_var)
    $env_hash = hiera($env_var)
    $env_string = hash2csv($env_hash)
  }
  elsif $environment {
    validate_hash($environment)
    $env_string = hash2csv($environment)
  }

  if $install_pip {
    include supervisord::pip
    Class['supervisord::pip'] -> Class['supervisord::install']
  }

  include supervisord::install, supervisord::config, supervisord::service

  Class['supervisord::install'] -> Class['supervisord::config'] ~> Class['supervisord::service']

}
