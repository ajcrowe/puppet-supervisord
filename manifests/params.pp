class supervisord::params {
  $package_ensure    = 'installed'
  $package_name      = 'supervisor'
  case $::osfamily {
    'Redhat': {
      $package_provider = 'yum'
    }
    'Debian': {
      $package_provider = 'apt'
    }
    default: {
      $package_provider = 'pip'
    }
  }
  case $package_provider {
    'pip': {
      $unix_socket_file = '/tmp/supervisor.sock' 
      $pidfile          = '/tmp/supervisord.pid'
      $logfile          = '/tmp/supervisord.log'
      $include_path     = '/etc/supervisord.d'
      $configfile       = '/etc/supervisord.conf'
    }
    default: {
      $unix_socket_file = '/var/run/supervisor.sock'
      $pidfile          = '/var/run/supervisord.pid'
      $logfile          = '/var/log/supervisor/supervisord.log'
      $include_path     = '/etc/supervisor/conf.d'
      $configfile       = '/etc/supervisor/supervisord.conf'
    }
  }

  $unix_socket          = true
  $unix_socket_mode     = '0700'
  $unix_socket_owner    = 'nobody'
  $unix_scoket_group    = 'nogroup'

  $inet_server          = false
  $inet_server_hostname = '127.0.0.1'
  $inet_server_port     = '9001'
  $inet_auth            = false

  $logfile_maxbytes     = '50MB'
  $logfile_backups      = '10'
  $log_level             = 'info'

  $nodaemon             = false
  $minfds               = '1024'
  $minprocs             = '200'
  $umask                = '022'

}