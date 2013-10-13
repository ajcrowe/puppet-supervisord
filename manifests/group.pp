define supervisord::group (
  $programs,
  $ensure   = present,
  $priority = undef
) {

  $conf = "${supervisord::params::include_path}/group_${name}.conf"

  file { "$conf":
    ensure  => $ensure,
    owner   => 'root',
    mode    => '0755',
    content => template('supervisord/conf/group.erb')
  }
}