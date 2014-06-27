# Class: supervisord::pip
#
# Optional class to install setuptool and pip
#
class supervisord::pip inherits supervisord {

  Exec {
    path => '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin'
  }

  if ! defined(Package['python-setuptools']) {
    package { 'python-setuptools': }
  }

  exec { 'install_pip':
    command     => '/usr/bin/easy_install pip',
    unless      => 'which pip',
    require     => Package['python-setuptools'],
  }

  if $::osfamily == 'RedHat' {
    exec { 'pip_provider_name_fix':
      command     => 'alternatives --install /usr/bin/pip-python pip-python /usr/bin/pip 1',
      subscribe   => Exec['install_pip'],
      unless      => 'which pip-python'
    }
  }
}
