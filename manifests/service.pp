class supervisord::service inherits supervisord  {
  service { 'supervisord':
    ensure     => $service_ensure,
    enable     => true,
    hasrestart => true,
    hasstatus  => true
  }
}
