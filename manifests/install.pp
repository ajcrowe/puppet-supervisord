# Class supervisord::install
#
# Installs supervisor package with pip
#
class supervisord::install inherits supervisord {
  package { 'supervisor':
    ensure   => $supervisord::package_ensure,
    provider => 'pip'
  }
}
