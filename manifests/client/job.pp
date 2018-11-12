define bacula::client::job (
  $client               = $name,
  $type                 = Backup,
  $backup_enable        = 'yes',
  $restore_enable       = 'yes',
  $storage_server_real  = undef,
  $client_schedule      = undef,
  $director_password    = '',
  $director_server_real = undef,
  $fileset              = 'Basic:noHome',
  $run_scripts_real     = undef,
  $storage_server       = undef,
  $pool                 = 'default',
  $rerun_failed_levels  = undef,
  $restore_where        = '/var/tmp/bacula-restores',
  $volume_autoprune     = 'Yes',
  $volume_retention     = '1 Year',
  $restore_where        = undef,
  $bootstrap            = undef,
) {

  file { "/etc/bacula/bacula-dir.d/jobs-${name}.conf":
    ensure  => file,
    owner   => 'bacula',
    group   => 'bacula',
    mode    => '0640',
    content => template('bacula/job.erb'),
    notify  => Exec['bacula-dir reload'],
  }

}

