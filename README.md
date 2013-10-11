# puppet-supervisord

Puppet module to manage supervisord programs [supervisord](http://supervisord.org/) monitoring tool.

This module is a WIP it might not be functional currently!

## Use Cases

### Install supervisord with defaults

```ruby
	include supervisord
```

### Install with pip and pip

```ruby
	class supervisord {
	  $package_provider => 'pip'
	  $install_init     => true
	}
```

### Configure a program

```ruby
	supervisord::program { 'myprogram':
	  command  => 'my_executable',
	  numprocs => '2',
	  priority => '100'
	}
```