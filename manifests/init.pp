# Class: supervisord
#
# This class installs supervisord via pip
#
# @param package_ensure
# @param package_name
# @param package_provider
# @param package_install_options
# @param service_manage
# @param service_ensure
# @param service_enable
# @param service_name
# @param service_restart
# @param install_pip
# @param pip_proxy
# @param install_init
# @param init_type
# @param init_mode
# @param init_script
# @param init_script_template
# @param init_defaults
# @param init_defaults_template
# @param setuptools_url
# @param executable
# @param executable_ctl
# @param scl_enabled
# @param scl_script
# @param log_path
# @param log_file
# @param log_level
# @param logfile_maxbytes
# @param logfile_backups
# @param run_path
# @param pid_file
# @param nodaemon
# @param minfds
# @param minprocs
# @param manage_config
# @param config_include
# @param config_include_purge
# @param config_file
# @param config_file_mode
# @param config_dirs
# @param umask
# @param ctl_socket
# @param unix_socket
# @param unix_socket_file
# @param unix_socket_mode
# @param unix_socket_owner
# @param unix_socket_group
# @param unix_auth
# @param unix_username
# @param unix_password
# @param inet_server
# @param inet_server_hostname
# @param inet_server_port
# @param inet_auth
# @param inet_username
# @param inet_password
# @param user
# @param group
# @param identifier
# @param childlogdir
# @param environment
# @param global_environment
# @param env_var
# @param directory
# @param strip_ansi
# @param nocleanup
# @param eventlisteners
# @param fcgi_programs
# @param groups
# @param programs
#
class supervisord (
  String $package_ensure                       = $supervisord::params::package_ensure,
  String $package_name                         = $supervisord::params::package_name,
  String $package_provider                     = $supervisord::params::package_provider,
  Optional[String] $package_install_options    = $supervisord::params::package_install_options,
  Boolean $service_manage                      = $supervisord::params::service_manage,
  String $service_ensure                       = $supervisord::params::service_ensure,
  Boolean $service_enable                      = $supervisord::params::service_enable,
  String $service_name                         = $supervisord::params::service_name,
  Optional[String] $service_restart            = $supervisord::params::service_restart,
  Boolean $install_pip                         = false,
  Optional[String] $pip_proxy                  = undef,
  Boolean $install_init                        = $supervisord::params::install_init,
  String $init_type                            = $supervisord::params::init_type,
  String $init_mode                            = $supervisord::params::init_mode,
  String $init_script                          = $supervisord::params::init_script,
  String $init_script_template                 = $supervisord::params::init_script_template,
  Variant[String, Boolean] $init_defaults      = $supervisord::params::init_defaults,
  String $init_defaults_template               = $supervisord::params::init_defaults_template,
  String $setuptools_url                       = $supervisord::params::setuptools_url,
  String $executable                           = $supervisord::params::executable,
  String $executable_ctl                       = $supervisord::params::executable_ctl,
  Boolean $scl_enabled                         = $supervisord::params::scl_enabled,
  String $scl_script                           = $supervisord::params::scl_script,
  String $log_path                             = $supervisord::params::log_path,
  String $log_file                             = $supervisord::params::log_file,
  String $log_level                            = $supervisord::params::log_level,
  String $logfile_maxbytes                     = $supervisord::params::logfile_maxbytes,
  Integer $logfile_backups                     = $supervisord::params::logfile_backups,
  String $run_path                             = $supervisord::params::run_path,
  String $pid_file                             = $supervisord::params::pid_file,
  Boolean $nodaemon                            = $supervisord::params::nodaemon,
  Integer $minfds                              = $supervisord::params::minfds,
  Integer $minprocs                            = $supervisord::params::minprocs,
  Boolean $manage_config                       = $supervisord::params::manage_config,
  String $config_include                       = $supervisord::params::config_include,
  Boolean $config_include_purge                = false,
  String $config_file                          = $supervisord::params::config_file,
  String $config_file_mode                     = $supervisord::params::config_file_mode,
  Optional[Array] $config_dirs                 = undef,
  String $umask                                = $supervisord::params::umask,
  String $ctl_socket                           = $supervisord::params::ctl_socket,
  Boolean $unix_socket                         = $supervisord::params::unix_socket,
  String $unix_socket_file                     = $supervisord::params::unix_socket_file,
  String $unix_socket_mode                     = $supervisord::params::unix_socket_mode,
  String $unix_socket_owner                    = $supervisord::params::unix_socket_owner,
  String $unix_socket_group                    = $supervisord::params::unix_socket_group,
  Boolean $unix_auth                           = $supervisord::params::unix_auth,
  Optional[String] $unix_username              = $supervisord::params::unix_username,
  Optional[String] $unix_password              = $supervisord::params::unix_password,
  Boolean $inet_server                         = $supervisord::params::inet_server,
  String $inet_server_hostname                 = $supervisord::params::inet_server_hostname,
  Integer $inet_server_port                    = $supervisord::params::inet_server_port,
  Boolean $inet_auth                           = $supervisord::params::inet_auth,
  Optional[String] $inet_username              = $supervisord::params::inet_username,
  Optional[String] $inet_password              = $supervisord::params::inet_password,
  String $user                                 = $supervisord::params::user,
  String $group                                = $supervisord::params::group,
  Optional[String] $identifier                 = undef,
  Optional[String] $childlogdir                = undef,
  Optional[Variant[String, Hash]] $environment = undef,
  Optional[Hash] $global_environment           = undef,
  Optional[Hash] $env_var                      = undef,
  Optional[String] $directory                  = undef,
  Boolean $strip_ansi                          = false,
  Boolean $nocleanup                           = false,
  Hash $eventlisteners                         = {},
  Hash $fcgi_programs                          = {},
  Hash $groups                                 = {},
  Hash $programs                               = {},
) inherits supervisord::params {
  if $unix_socket and $inet_server {
    $use_ctl_socket = $ctl_socket
  }
  elsif $unix_socket {
    $use_ctl_socket = 'unix'
  }
  elsif $inet_server {
    $use_ctl_socket = 'inet'
  }

  if $use_ctl_socket == 'unix' {
    $ctl_serverurl = "unix://${supervisord::run_path}/${supervisord::unix_socket_file}"
    $ctl_auth      = $supervisord::unix_auth
    $ctl_username  = $supervisord::unix_username
    $ctl_password  = $supervisord::unix_password
  }
  elsif $use_ctl_socket == 'inet' {
    $ctl_serverurl = "http://${supervisord::inet_server_hostname}:${supervisord::inet_server_port}"
    $ctl_auth      = $supervisord::inet_auth
    $ctl_username  = $supervisord::inet_username
    $ctl_password  = $supervisord::inet_password
  }

  # Handle deprecated $environment variable
  if $environment { notify { '[supervisord] *** DEPRECATED WARNING ***: $global_environment has replaced $environment': } }
  $_global_environment = $global_environment ? {
    undef   => $environment,
    default => $global_environment
  }

  if $env_var {
    $env_hash = hiera($env_var)
    $env_string = hash2csv($env_hash)
  }
  elsif $_global_environment {
    $env_string = hash2csv($_global_environment)
  }

  if $config_dirs {
    $config_include_string = join($config_dirs, ' ')
  }
  else {
    $config_include_string = "${config_include}/*.conf"
  }

  create_resources('supervisord::eventlistener', $eventlisteners)
  create_resources('supervisord::fcgi_program', $fcgi_programs)
  create_resources('supervisord::group', $groups)
  create_resources('supervisord::program', $programs)

  if $install_pip {
    include supervisord::pip
    Class['supervisord::pip'] -> Class['supervisord::install']
  }

  include supervisord::install, supervisord::config, supervisord::service, supervisord::reload

  contain 'supervisord::install'
  contain 'supervisord::config'
  contain 'supervisord::service'

  Class['supervisord::install']
  -> Class['supervisord::config']
  ~> Class['supervisord::service']

  Class['supervisord::service'] -> Supervisord::Program <| |>
  Class['supervisord::service'] -> Supervisord::Fcgi_program <| |>
  Class['supervisord::service'] -> Supervisord::Eventlistener <| |>
  Class['supervisord::service'] -> Supervisord::Group <| |>
  Class['supervisord::service'] -> Supervisord::Rpcinterface <| |>
  Class['supervisord::reload']  -> Supervisord::Supervisorctl <| |>
}
