# Class: supervisord::config
#
# Configuration class for supervisor init and conf directories
#
class supervisord::config inherits supervisord {

  file { $supervisord::config_include:
    ensure  => directory,
    owner   => 'root',
    mode    => '0755',
    recurse => $supervisord::config_include_purge,
    purge   => $supervisord::config_include_purge,
  }

  file { $supervisord::log_path:
    ensure => directory,
    owner  => 'root',
    mode   => '0644'
  }

  if $supervisord::run_path != '/var/run' {
    file { $supervisord::run_path:
      ensure => directory,
      owner  => 'root',
      mode   => '0644'
    }
  }

  if $supervisord::install_init {
    file { '/etc/init.d/supervisord':
      ensure  => present,
      owner   => 'root',
      mode    => '0755',
      content => template("supervisord/init/${::osfamily}/init.erb"),
      notify  => Class['supervisord::service'],
    }

    if $supervisord::init_defaults {
      file { $supervisord::init_defaults:
        ensure  => present,
        owner   => 'root',
        mode    => '0755',
        content => template($supervisord::init_template),
        notify  => Class['supervisord::service'],
      }
    }
  }

  concat { $supervisord::config_file:
    owner => 'root',
    group => '0',
    mode  => '0644'
  }

  if $supervisord::unix_socket {
    concat::fragment { 'supervisord_unix':
      target  => $supervisord::config_file,
      content => template('supervisord/supervisord_unix.erb'),
      order   => 01
    }
  }

  if $supervisord::inet_server {
    concat::fragment { 'supervisord_inet':
      target  => $supervisord::config_file,
      content => template('supervisord/supervisord_inet.erb'),
      order   => 01
    }
  }

  concat::fragment { 'supervisord_main':
    target  => $supervisord::config_file,
    content => template('supervisord/supervisord_main.erb'),
    order   => 02
  }
}
