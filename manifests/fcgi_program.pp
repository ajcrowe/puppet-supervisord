# Define: supervisord::fcgi_program
#
# This define creates an eventlistener configuration file
#
# Documentation on parameters available at:
# http://supervisord.org/configuration.html#fcgi-program-x-section-settings
#
define supervisord::fcgi_program(
  $command,
  $socket,
  $ensure                  = present,
  $socket_owner            = undef,
  $socket_mode             = undef,
  $env_var                 = undef,
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
  $stdout_logfile          = "fcgi-program_${name}.log",
  $stdout_logfile_maxbytes = undef,
  $stdout_logfile_backups  = undef,
  $stdout_capture_maxbytes = undef,
  $stdout_events_enabled   = undef,
  $stderr_logfile          = "fcgi-program_${name}.error",
  $stderr_logfile_maxbytes = undef,
  $stderr_logfile_backups  = undef,
  $stderr_capture_maxbytes = undef,
  $stderr_events_enabled   = undef,
  $environment             = undef,
  $directory               = undef,
  $umask                   = undef,
  $serverurl               = undef
) {

  include supervisord

  # parameter validation
  validate_string($command)
  validate_re($socket, ['^tcp:\/\/.*:\d+$', '^unix:\/\/\/'])
  if $priority { validate_re($priority, '^\d+', "invalid priority value of: ${priority}") }
  if $umask { validate_re($umask, '^0[0-7][0-7]$', "invalid umask: ${umask}.") }

  if $env_var {
    $env_hash = hiera_hash($env_var)
    validate_hash($env_hash)
    $env_string = hash2csv($env_hash)
  }
  elsif $environment {
    validate_hash($environment)
    $env_string = hash2csv($environment)
  }

  $conf = "${supervisord::config_include}/fcgi-program_${name}.conf"

  file { $conf:
    ensure  => $ensure,
    owner   => 'root',
    mode    => '0755',
    content => template('supervisord/conf/fcgi_program.erb'),
    notify  => Class['supervisord::service']
  }
}
