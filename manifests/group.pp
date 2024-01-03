# Define: supervisord::group
#
# This define creates an group configuration file
#
# Documentation on parameters available at:
# http://supervisord.org/configuration.html#group-x-section-settings
#
# @param programs
# @param ensure
# @param priority
# @param config_file_mode
#
define supervisord::group (
  Optional[Array] $programs   = undef,
  String $ensure              = 'present',
  Optional[Integer] $priority = undef,
  String $config_file_mode    = '0644',
) {
  include supervisord

  $progstring = array2csv($programs)
  $conf = "${supervisord::config_include}/group_${name}.conf"

  file { $conf:
    ensure  => $ensure,
    owner   => 'root',
    mode    => $config_file_mode,
    content => template('supervisord/conf/group.erb'),
    notify  => Class['supervisord::reload'],
  }
}
