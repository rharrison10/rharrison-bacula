# == Define: bacula::director::pool
#
# Include a pool configuration file in <tt>/etc/bacula/bacula-dir.d/pools.conf</tt>.
#
# === Parameters
#
# === Examples
#
# Provide some examples on how to use this type:
#
#   bacula::director::pool { 'namevar' :
#     label_ext => full,
#   }
#
define bacula::director::pool (
  $pool_type        = 'Backup',
  $label_format     = '${Client}.${Year}${Month:p/2/0/r}${Day:p/2/0/r}.${Hour:p/2/0/r}${Minute:p/2/0/r}',
  $label_ext        = undef,
  $recycle          = 'Yes',
  $auto_prune       = 'Yes',
  $volume_retention = '1 Week',
  $max_volume_bytes = '100G',
  $max_volume_jobs  = 20,
  $subdir           = 'bacula-dir.d',
) {
    if $label_ext == '' {
      $fin_label_format = "${label_format}"
    } else {
      $fin_label_format = "${label_format}.${label_ext}"
    }

  concat::fragment { "${name}":
    ensure  => present,
    target  => "/etc/bacula/${subdir}/pools.conf",
    content => template('bacula/pool.erb'),
  }



}
