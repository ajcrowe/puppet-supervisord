define supervisord::program(
  $command,
  $process_name            = undef,
  $numprocs                = undef,
  $numprocs_start          = undef,
  $priority                = undef,
  $autostart               = undef,
  $autorestart             = undef,
  $startsecs               = undef,
  $startretries            = undef,
  $exitcodes               = undef,
  $stopsignal              = undef,
  $stopwaitsec             = undef,
  $stopasgroup             = undef,
  $killasgroup             = undef,
  $user                    = undef,
  $redirect_stderr         = undef,
  $stdout_logfile          = undef,
  $stdout_logfile_maxbytes = undef,
  $stdout_logfile_backups  = undef,
  $stdout_capture_maxbytes = undef,
  $stdout_events_enabled   = undef,
  $stderr_logfile          = undef,
  $stderr_logfile_maxbytes = undef,
  $stderr_logfile_backups  = undef,
  $stderr_capture_maxbytes = undef,
  $stderr_events_enabled   = undef,
  $environment             = undef,
  $directory               = undef,
  $umask                   = undef,
  $serverurl               = undef,
) {

  $programconf = "${supervisord::params::include_path}/${name}-program.conf"

  file { "$programconf":
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    content => template('supervisord/program.erb')
  }
}