# Class: supervisord::reload
#
# Class to reread and update supervisord with supervisorctl
#
class supervisord::reload inherits supervisord {
  if $supervisord::service_manage {
    $supervisorctl = $supervisord::executable_ctl

    exec { 'supervisorctl_reread':
      command     => "${supervisorctl} reread",
      refreshonly => true,
      onlyif      => "ps cax | grep ${supervisord::service_name} | grep -v grep",
      require     => Service[$supervisord::service_name],
    }
    exec { 'supervisorctl_update':
      command     => "${supervisorctl} update",
      refreshonly => true,
      onlyif      => "ps cax | grep ${supervisord::service_name} | grep -v grep",
      require     => Service[$supervisord::service_name],
    }
  }
}
