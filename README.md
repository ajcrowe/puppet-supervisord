# puppet-supervisord

Puppet module to manage supervisord programs [supervisord](http://supervisord.org/) monitoring tool.

This module is a WIP it might not be functional currently!

## Use Cases

### Install supervisord with defaults from apt or yum

```ruby
include supervisord
```

### Install pip, configure an init script (only includes Debian and RedHat families)

```ruby
class supervisord {
  $install_init => true,
  $install_pip  => true,
}
```

### Configure a program

```ruby
supervisord::program { 'myprogram':
  command  => 'command --args',
  numprocs => '2',
  priority => '100'
}
```

## Configure a group

```ruby
supervisord::group { 'mygroup':
  priority => 100
}
```
### Credits

* Debian init script sourced from the system package.
* RedHat/Centos init script sourced from https://github.com/Supervisor/initscripts 