# puppet-supervisord

Puppet module to manage supervisord programs [supervisord](http://supervisord.org/) monitoring tool.

This module is a WIP it might not be functional currently!

## Use Cases

### Install supervisord with defaults from apt or yum

```ruby
include supervisord
```

### Install with pip and configure an init script

```ruby
class supervisord {
  $package_provider => 'pip'
  $install_init     => true
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