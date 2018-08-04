# Class: supervisord::service
#
# Class for the supervisord service
#
class supervisord::service inherits supervisord  {
  if $::supervisord::service_manage {
    if $::supervisord::init_type == 'systemd' {
      exec { 'refresh_supervisord_unit':
        command     => '/usr/bin/env systemctl daemon-reload',
        refreshonly => true,
        before      => Service[$::supervisord::service_name],
      }
    }

    service { $::supervisord::service_name:
      ensure     => $::supervisord::service_ensure,
      enable     => $::supervisord::service_enable,
      hasrestart => true,
      hasstatus  => true,
      restart    => $::supervisord::service_restart,
    }
  }
}
