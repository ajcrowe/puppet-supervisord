class supervisord::install inherits supervisord {
  package { 'supervisor':
    ensure   => "$package_ensure",
    provider => 'pip'
  }
}
