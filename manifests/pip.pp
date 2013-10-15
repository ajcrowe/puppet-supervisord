class supervisord::pip inherits supervisord {

  Exec {
    path => '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin'
  }

  exec { 'install_setuptools':
    command => "curl ${setuptools_url} | python",
    cwd     => '/tmp',
    unless  => 'which easy_install'
  }

  exec { 'install_pip':
    command     => 'easy_install pip',
    refreshonly => true,
    subscribe   => Exec['install_setuptools'],
    unless      => 'which pip'
  }

  if $::osfamily == 'RedHat' {
    exec { 'pip_provider_name_fix':
      command     => 'alternatives --install /usr/bin/pip-python pip-python /usr/bin/pip 1',
      subscribe   => Exec['install_pip'],
      unless      => 'which pip-python'
    }
  }
}
