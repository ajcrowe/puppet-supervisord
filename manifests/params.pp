class supervisord::params {
  $package_ensure       = 'installed'
  $package_name         = 'supervisor'

  case ::osfamily {
    'RedHat': {
      $init_extras       = '/etc/sysconfig/supervisord'
    }
    'Debian': {
      $init_extras       = '/etc/default/supervisor'
    }
    default: {
      $init_extras       = undef
    }
  }

  $run_path             = '/var/run'
  $pid_file             = "${run_path}/supervisord.pid"
  $log_path             = '/var/log/supervisor'
  $log_file             = "{log_path}/supervisord.log"
  $logfile_maxbytes     = '50MB'
  $logfile_backups      = '10'
  $log_level            = 'info'
  $nodaemon             = false
  $minfds               = '1024'
  $minprocs             = '200'
  $umask                = '022'
  $config_path          = '/etc/supervisor'
  $config_include       = "${config_path}/conf.d"
  $config_file          = "${config_path}/supervisord.conf"
  $setuptools_url       = 'https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py'

  $unix_socket          = true
  $unix_socket_file     = "${run_path}/supervisor.sock"
  $unix_socket_mode     = '0700'
  $unix_socket_owner    = 'nobody'
  $unix_scoket_group    = 'nogroup'

  $inet_server          = false
  $inet_server_hostname = '127.0.0.1'
  $inet_server_port     = '9001'
  $inet_auth            = false
}