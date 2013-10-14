define supervisord::group (
  $programs,
  $ensure   = present,
  $priority = undef
) {

  $conf = "${supervisord::config_include}/group_${name}.conf"

  file { "$conf":
    ensure  => $ensure,
    owner   => 'root',
    mode    => '0755',
    content => template('supervisord/conf/group.erb')
  }
}