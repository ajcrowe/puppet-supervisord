# Define: supervisord::eventlistener
#
# This define creates an eventlistener configuration file
#
# Documentation on parameters available at:
# http://supervisord.org/configuration.html#eventlistener-x-section-settings
#
# @param command
# @param ensure
# @param ensure_process
# @param buffer_size
# @param events
# @param result_handler
# @param env_var
# @param process_name
# @param numprocs
# @param numprocs_start
# @param priority
# @param autostart
# @param autorestart
# @param startsecs
# @param startretries
# @param exitcodes
# @param stopsignal
# @param stopwaitsecs
# @param stopasgroup
# @param killasgroup
# @param user
# @param redirect_stderr
# @param stdout_logfile
# @param stdout_logfile_maxbytes
# @param stdout_logfile_backups
# @param stdout_events_enabled
# @param stderr_logfile
# @param stderr_logfile_maxbytes
# @param stderr_logfile_backups
# @param stderr_events_enabled
# @param environment
# @param event_environment
# @param directory
# @param umask
# @param serverurl
# @param config_file_mode
#
define supervisord::eventlistener (
  Optional[String] $command                    = undef,
  String $ensure                               = 'present',
  String $ensure_process                       = 'running',
  Integer $buffer_size                         = 10,
  Optional[Array] $events                      = undef,
  Optional[String] $result_handler             = undef,
  Optional[Variant[Hash, String]] $env_var     = undef,
  Optional[String] $process_name               = undef,
  Optional[Integer] $numprocs                  = undef,
  Optional[Integer] $numprocs_start            = undef,
  Optional[Integer] $priority                  = undef,
  Optional[Boolean] $autostart                 = undef,
  Optional[Boolean] $autorestart               = undef,
  Optional[Integer] $startsecs                 = undef,
  Optional[Integer] $startretries              = undef,
  Optional[String] $exitcodes                  = undef,
  Optional[String] $stopsignal                 = undef,
  Optional[Integer] $stopwaitsecs              = undef,
  Optional[Boolean] $stopasgroup               = undef,
  Optional[Boolean] $killasgroup               = undef,
  Optional[String] $user                       = undef,
  Optional[Boolean] $redirect_stderr           = undef,
  String $stdout_logfile                       = "eventlistener_${name}.log",
  Optional[String] $stdout_logfile_maxbytes    = undef,
  Optional[Integer] $stdout_logfile_backups    = undef,
  Optional[Boolean] $stdout_events_enabled     = undef,
  String $stderr_logfile                       = "eventlistener_${name}.error",
  Optional[String] $stderr_logfile_maxbytes    = undef,
  Optional[Integer] $stderr_logfile_backups    = undef,
  Optional[Boolean] $stderr_events_enabled     = undef,
  Optional[Variant[String, Hash]] $environment = undef,
  Optional[Hash] $event_environment            = undef,
  Optional[String] $directory                  = undef,
  Optional[String] $umask                      = undef,
  Optional[String] $serverurl                  = undef,
  String $config_file_mode                     = '0644',
) {
  include supervisord

  # create the correct log variables
  $stdout_logfile_path = $stdout_logfile ? {
    /(NONE|AUTO|syslog)/ => $stdout_logfile,
    /^\//                => $stdout_logfile,
    default              => "${supervisord::log_path}/${stdout_logfile}",
  }

  $stderr_logfile_path = $stderr_logfile ? {
    /(NONE|AUTO|syslog)/ => $stderr_logfile,
    /^\//                => $stderr_logfile,
    default              => "${supervisord::log_path}/${stderr_logfile}",
  }

  # Handle deprecated $environment variable
  if $environment { notify { '[supervisord] *** DEPRECATED WARNING ***: $event_environment has replaced $environment': } }
  $_event_environment = $event_environment ? {
    undef   => $environment,
    default => $event_environment
  }

  # convert environment data into a csv
  if $env_var {
    $env_hash = hiera_hash($env_var)
    $env_string = hash2csv($env_hash)
  }
  elsif $_event_environment {
    $env_string = hash2csv($_event_environment)
  }

  if $events {
    $events_string = array2csv($events)
  }

  $conf = "${supervisord::config_include}/eventlistener_${name}.conf"

  file { $conf:
    ensure  => $ensure,
    owner   => 'root',
    mode    => $config_file_mode,
    content => template('supervisord/conf/eventlistener.erb'),
    notify  => Class['supervisord::reload'],
  }

  case $ensure_process {
    'stopped': {
      supervisord::supervisorctl { "stop_${name}":
        command => 'stop',
        process => $name,
      }
    }
    'removed': {
      supervisord::supervisorctl { "remove_${name}":
        command => 'remove',
        process => $name,
      }
    }
    'running': {
      supervisord::supervisorctl { "start_${name}":
        command => 'start',
        process => $name,
        unless  => 'running',
      }
    }
    default: {
    }
  }
}
