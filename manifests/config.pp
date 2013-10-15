class supervisord::config inherits supervisord { 
  file { ["${config_include}", "${run_path}", "${log_path}"]:
    ensure => directory,
    owner  => 'root',
    mode   => '0755'
  }

  if $install_init {

    $osname = downcase($::osfamily)

    file { '/etc/init.d/supervisord':
      ensure  => present,
      owner   => 'root',
      mode    => '0755',
      content => template("supervisord/init/${osname}_init.erb")
    }

    if $init_extras {
      file { "$init_extras":
        ensure  => present,
        owner   => 'root',
        mode    => '0755',
        content => template("supervisord/init/${osname}_extra.erb")
      }      
    }

  }

  concat { $config_file:
    owner => 'root',
    group => 'root',
    mode  => '0755'
  }

  if $unix_socket {
    concat::fragment { 'supervisord_unix':
      target  => $config_file,
      content => template('supervisord/supervisord_unix.erb'),
      order   => 01
    }
  }

  if $inet_server {
    concat::fragment { 'supervisord_inet':
      target  => $config_file,
      content => template('supervisord/supervisord_inet.erb'),
      order   => 01
    }
  }

  concat::fragment { 'supervisord_main':
    target  => $config_file,
    content => template('supervisord/supervisord_main.erb'),
    order   => 02
  }
}