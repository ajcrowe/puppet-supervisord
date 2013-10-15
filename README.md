# puppet-supervisord

Puppet module to manage the [supervisord](http://supervisord.org/) process control system.

Functions available to configure 

* [programs](http://supervisord.org/configuration.html#program-x-section-settings)
* [groups](http://supervisord.org/configuration.html#group-x-section-settings)
* [fcgi-programs](http://supervisord.org/configuration.html#fcgi-program-x-section-settings)
* [eventlisteners](http://supervisord.org/configuration.html#eventlistener-x-section-settings)

## Examples

### Configuring supervisord with defaults

Install supervisord with pip and install an init script if available

```ruby
include supervisord
```

### Install supervisord and pip

Install supervisord and install pip if not available.

```ruby
class supervisord {
  $install_pip  => true,
}
```

This will download [setuptool](https://bitbucket.org/pypa/setuptools) and install pip with easy_install. 

You can pass a specific url with `$setuptools_url = 'url'`

Note: Only Debian and RedHat families have an init script currently.

### Configure a program

```ruby
supervisord::program { 'myprogram':
  command     => 'command --args',
  priority    => '100'
  environment => {
    HOME   => '/home/myuser',
    PATH   => '/bin:/sbin:/usr/bin:/usr/sbin',
    SECRET => 'mysecret'
  }
}
```

You may also specify a variable for a hiera lookup to retreive your environment hash. This allows you to reuse existing environment variable hashes.

```ruby
supervisord::program { 'myprogram':
  command  => 'command --args',
  priority => '100'
  env_var  => 'my_common_envs'
}
```

### Configure a group

```ruby
supervisord::group { 'mygroup':
  priority => 100,
  program  => ['program1', 'program2', 'program3']
}
```

### ToDo

* eventlistener template and function
* fcgiprogram template and function
* Write spec tests for custom functions

### Credits

* Debian init script sourced from the system package.
* RedHat/Centos init script sourced from https://github.com/Supervisor/initscripts 