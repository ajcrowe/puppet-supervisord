class supervisord::install {
  package { 'supervisor':
    ensure   => "$package_ensure",
    provider => 'pip'
  }
}