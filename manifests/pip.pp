class supervisord::pip {
  exec { 'install_setuptools':
    command => "curl ${setuptools_url} | python",
    cwd     => '/tmp',
    path    => '/sbin:/bin:/usr/sbin:/usr/bin:/root/bin',
    unless  => 'which easy_install'
  }

  exec { 'install_pip':
    command     => '/usr/bin/easy_install pip',
    refreshonly => true,
    subscribe   => Exec['install_setuptools'],
    unless      => 'which pip'
  }

  if ::osfamily == 'RedHat' {
    exec { 'pip_provider_bugfix':
      command     => '/usr/sbin/alternatives --install /usr/bin/pip-python pip-python /usr/bin/pip 1',
      refreshonly => true,
      subscribe   => Exec['install_pip']
      unless      => 'which pip-python'
    }
  }
}