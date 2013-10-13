class supervisord::config inherits supervisord::params { 
  file { ["${config_path}", "${include_path}", "${run_path}", "${log_path}"]:
    ensure => directory,
    owner  => "$user",
    mode   => '0750'
  }

  if $install_init {

    $supported = $::osfamily ? {
      'RedHat' => 'redhat',
      'Debian' => 'debian',
      default  => false,
    }

    unless $supported {
      fail("No init script for osfamily: ${::osfamily}")
    }
  
    file { "$supervisord::params::init_extras":
      ensure  => present,
      owner   => 'root',
      mode    => '0755',
      content => template("supervisord/init/${os_lower}_extra.erb")
    }      

    file { '/etc/init.d/supervisord':
      ensure  => present,
      owner   => 'root',
      mode    => '0755',
      content => template("supervisord/init/${os_lower}_init")
    }
  }

  concat { $config_file:
    owner => "$user",
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