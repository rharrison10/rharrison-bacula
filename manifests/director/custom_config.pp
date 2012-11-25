# == Define: bacula::director::custom_config
#
# Include a custom configuration file in +/etc/bacula/bacula-dir.d+.
#
# === Parameters
#
# [*ensure*]
#   Ensure the file is present or absent.  The only valid values are +file+ or
#   +absent+. Defaults to +file+.
# [*director_server*]
#   WHere this config will be deployed, if using stored configs.
# [*content*]
#   String containing the content for the configuration file.  Usually supplied
#   with a template.
# [*source*]
#   The source location of the configuration file to deploy in +bacula-dir.d+.
#
# === Examples
#
# Provide some examples on how to use this type:
#
#   bacula::director::custom_config { 'namevar' :
#     ensure => file,
#     source => 'puppet:///modules/my_bacula/custom.conf'
#   }
#
define bacula::director::custom_config (
  $ensure   = 'file',
  $director_server = undef,
  $content  = undef,
  $source   = undef
) {
  if !($ensure in ['file', 'absent']) {
    fail('The only valid values for the ensure parameter are file or absent')
  }

  if $content and $source {
    fail('You may not supply both content and source parameters')
  } elsif $content == undef and $source == undef {
    fail('You must supply either the content or source parameter')
  }

  file { "/etc/bacula/bacula-dir.d/custom-${name}.conf":
    ensure  => file,
    owner   => 'bacula',
    group   => 'bacula',
    mode    => '0640',
    content => $content,
    source  => $source,
    require => File['/etc/bacula/bacula-dir.conf'],
    notify  => Service['bacula-dir'],
  }
}
