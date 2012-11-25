# == Class: bacula
#
# This is the main class to manage all the components of a Bacula
# infrastructure. This is the only class that needs to be declared.
#
# === Parameters:
#
# [*clients*]
#   For directors, +$clients+ is a hash of clients.  The keys are the clients while the value is a hash of parameters. The
#   parameters accepted are the same as the +bacula::client::config+ define.
# [*console_password*]
#   The console's password
# [*console_template*]
#   The ERB template to use for configuring the bconsole instead of the one
#   included with the module
# [*db_backend*]
#   The database backend to use
# [*db_database*]
#   The db database to connect to on +$db_host+
# [*db_host*]
#   The db server host to connect to
# [*db_password*]
#   The password to authenticate +$db_user+ with
# [*db_port*]
#   The port to connect to the database server on
# [*db_user*]
#   The user to authenticate to +$db_db+ with.
# [*db_user_host*]
#   The host string used by MySQL to allow connections from
# [*director_password*]
#   The director's password
# [*director_server*]
#   The FQDN of the bacula director
# [*director_template*]
#   The ERB template to use for configuring the director instead of the one
#   included with the module
# [*is_client*]
#   Whether the node should be a client
# [*is_director*]
#   Whether the node should be a director
# [*is_storage*]
#   Whether the node should be a storage server
# [*mail_to*]
#   Address to email reports to
# [*manage_console*]
#   Whether the bconsole should be managed on the node
# [*manage_bat*]
#   Whether the bat should be managed on the node
# [*manage_config_dir*]
#   Whether to purge all non-managed files from the bacula config directory
# [*manage_db*]
#   Whether to manage the existence of the database.  If true, the +$db_user+
#   must have privileges to create databases on +$db_host+
# [*manage_db_tables*]
#   Whether to create the DB tables during install
# [*manage_logwatch*]
#   Whether to configure logwatch on the director
# [*plugin_dir*]
#   The directory Bacula plugins are stored in. Use this parameter if you want to override the default plugin
#   location. If this is anything other than +undef+ it will also configure plugins on older distros were the default
#   package is too old to support plugins.  Only use if the version in the distro repositories supports plugins or
#   you have included a respository with a newer Bacula packaged for your distro.
# [*storage_default_mount*]
#   Directory where the default disk for file backups is mounted. A subdirectory named +default+ will be created allowing you to
#   define additional devices in Bacula which use the same disk. Defaults to +'/mnt/bacula'+.
# [*storage_server*]
#   The FQDN of the storage server
# [*storage_template*]
#   The ERB template to use for configuring the storage daemon instead of the
#   one included with the module
# [*tls_allowed_cn*]
#   Array of common name attribute of allowed peer certificates. If this directive is specified, all server
#   certificates will be verified against this list. This can be used to ensure that only the CA-approved Director
#   may connect.
# [*tls_ca_cert*]
#   The full path and filename specifying a PEM encoded TLS CA certificate(s). Multiple certificates are permitted in
#   the file. One of +TLS CA Certificate File+ or +TLS CA Certificate Dir+ are required in a server context if
#   +TLS Verify Peer+ is also specified, and are always required in a client context.
# [*tls_ca_cert_dir*]
#   Full path to TLS CA certificate directory. In the current implementation, certificates must be stored PEM
#   encoded with OpenSSL-compatible hashes, which is the subject name's hash and an extension of .0. One of
#   +TLS CA Certificate File+ or +TLS CA Certificate Dir+ are required in a server context if +TLS Verify Peer+ is
#   also specified, and are always required in a client context.
# [*tls_cert*]
#   The full path and filename of a PEM encoded TLS certificate. It can be used as either a client or server
#   certificate. PEM stands for Privacy Enhanced Mail, but in this context refers to how the certificates are
#   encoded. It is used because PEM files are base64 encoded and hence ASCII text based rather than binary. They may
#   also contain encrypted information.
# [*tls_key*]
#   The full path and filename of a PEM encoded TLS private key. It must correspond to the TLS certificate.
# [*tls_require*]
#   Require TLS connections. This directive is ignored unless +TLS Enable+ is set to yes. If TLS is not required,
#   and TLS is enabled, then Bacula will connect with other daemons either with or without TLS depending on what the
#   other daemon requests. If TLS is enabled and TLS is required, then Bacula will refuse any connection that does
#   not use TLS. Valid values are +'yes'+ or +'no'+.
# [*tls_verify_peer*]
#   Verify peer certificate. Instructs server to request and verify the client's x509 certificate. Any client
#   certificate signed by a known-CA will be accepted unless the +TLS Allowed CN+ configuration directive is used, in
#   which case the client certificate must correspond to the Allowed Common Name specified. Valid values are +'yes'+
#   or +'no'+.
# [*use_console*]
#   Whether to configure a console resource on the director
# [*use_tls*]
#   Whether to use {Bacula TLS - Communications
#   Encryption}[http://www.bacula.org/en/dev-manual/main/main/Bacula_TLS_Communications.html].
#
# === Sample Usage
#
#  $clients = {
#    'node1.example.com' => {
#      'fileset'         => 'Basic:noHome',
#      'client_schedule' => 'Hourly',
#    },
#    'node2.example.com' => {
#      'fileset'         => 'Basic:noHome',
#      'client_schedule' => 'Hourly',
#    }
#  }
#
#  class { 'bacula':
#    is_storage        => true,
#    is_director       => true,
#    is_client         => true,
#    manage_console    => true,
#    director_password => 'xxxxxxxxx',
#    console_password  => 'xxxxxxxxx',
#    director_server   => 'bacula.domain.com',
#    mail_to           => 'bacula-admin@domain.com',
#    storage_server    => 'bacula.domain.com',
#    clients           => $clients,
#  }
#
# === Copyright
#
# Copyright 2012 Russell Harrison
#
# === License
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
class bacula (
  $console_password      = '',
  $console_template      = undef,
  $db_backend            = 'sqlite',
  $db_user               = '',
  $db_password           = '',
  $db_host               = 'localhost',
  $db_user_host          = undef,
  $db_database           = 'bacula',
  $db_port               = '3306',
  $director_password     = '',
  $director_server       = undef,
  $director_template     = undef,
  $is_client             = true,
  $is_director           = false,
  $is_storage            = false,
  $mail_to               = undef,
  $manage_config_dir     = false,
  $manage_db             = false,
  $manage_db_tables      = true,
  $manage_logwatch       = undef,
  $manage_console        = false,
  $manage_bat            = false,
  $plugin_dir            = undef,
  $storage_default_mount = '/mnt/bacula',
  $storage_server        = undef,
  $storage_template      = undef,
  $tls_allowed_cn        = [],
  $tls_ca_cert           = undef,
  $tls_ca_cert_dir       = undef,
  $tls_cert              = undef,
  $tls_key               = undef,
  $tls_require           = 'yes',
  $tls_verify_peer       = 'yes',
  $use_console           = false,
  $use_tls               = false,
  $clients               = {}
) {
  include bacula::params

  $director_server_real = $director_server ? {
    undef   => $bacula::params::director_server_default,
    default => $director_server,
  }
  $storage_server_real  = $storage_server ? {
    undef   => $bacula::params::storage_server_default,
    default => $storage_server,
  }
  $mail_to_real         = $mail_to ? {
    undef   => $bacula::params::mail_to_default,
    default => $mail_to,
  }

  case $plugin_dir {
    undef   : {
      $use_plugins     = $bacula::params::use_plugins
      $plugin_dir_real = $bacula::params::plugin_dir
    }
    default : {
      $use_plugins     = true
      $plugin_dir_real = $plugin_dir
    }
  }

  case $manage_logwatch {
    undef   : { 
      $manage_logwatch_real = $bacula::params::manage_logwatch 
    }
    default : { 
      $manage_logwatch_real = $manage_logwatch
    }
  }

  # Validate our parameters
  # It's ugly to do it in the parent class
  class { 'bacula::params::validate':
    console_password      => $console_password,
    db_backend            => $db_backend,
    db_database           => $db_database,
    db_host               => $db_host,
    db_password           => $db_password,
    db_port               => $db_port,
    db_user               => $db_user,
    director_password     => $director_password,
    director_server       => $director_server_real,
    is_client             => $is_client,
    is_director           => $is_director,
    is_storage            => $is_storage,
    mail_to               => $mail_to_real,
    manage_bat            => $manage_bat,
    manage_config_dir     => $manage_config_dir,
    manage_console        => $manage_console,
    manage_db             => $manage_db,
    manage_db_tables      => $manage_db_tables,
    manage_logwatch       => $manage_logwatch_real,
    plugin_dir            => $plugin_dir_real,
    storage_default_mount => $storage_default_mount,
    storage_server        => $storage_server_real,
    tls_allowed_cn        => $tls_allowed_cn,
    tls_ca_cert           => $tls_ca_cert,
    tls_ca_cert_dir       => $tls_ca_cert_dir,
    tls_cert              => $tls_cert,
    tls_key               => $tls_key,
    tls_require           => $tls_require,
    tls_verify_peer       => $tls_verify_peer,
    use_console           => $use_console,
    use_plugins           => $use_plugins,
    use_tls               => $use_tls,
  }

  class { 'bacula::common':
    db_backend       => $db_backend,
    db_database      => $db_database,
    db_host          => $db_host,
    db_password      => $db_password,
    db_port          => $db_port,
    db_user          => $db_user,
    is_client        => $is_client,
    is_director      => $is_director,
    is_storage       => $is_storage,
    manage_bat       => $manage_bat,
    manage_config_dir => $manage_config_dir,
    manage_console   => $manage_console,
    manage_db_tables => $manage_db_tables,
    plugin_dir       => $plugin_dir_real,
    use_plugins      => $use_plugins,
  }

  if $is_director {
    class { 'bacula::director':
      clients           => $clients,
      console_password  => $console_password,
      db_backend        => $db_backend,
      db_database       => $db_database,
      db_host           => $db_host,
      db_password       => $db_password,
      db_port           => $db_port,
      db_user           => $db_user,
      db_user_host      => $db_user_host,
      dir_template      => $director_template,
      director_password => $director_password,
      director_server   => $director_server_real,
      mail_to           => $mail_to_real,
      manage_db         => $manage_db,
      manage_db_tables  => $manage_db_tables,
      manage_logwatch   => $manage_logwatch_real,
      plugin_dir        => $plugin_dir_real,
      storage_server    => $storage_server_real,
      tls_allowed_cn    => $tls_allowed_cn,
      tls_ca_cert       => $tls_ca_cert,
      tls_ca_cert_dir   => $tls_ca_cert_dir,
      tls_cert          => $tls_cert,
      tls_key           => $tls_key,
      tls_require       => $tls_require,
      tls_verify_peer   => $tls_verify_peer,
      use_console       => $use_console,
      use_plugins       => $use_plugins,
      use_tls           => $use_tls,
    }
  }

  if $is_storage {
    class { 'bacula::storage':
      console_password      => $console_password,
      db_backend            => $db_backend,
      director_password     => $director_password,
      director_server       => $director_server_real,
      plugin_dir            => $plugin_dir_real,
      storage_default_mount => $storage_default_mount,
      storage_server        => $storage_server_real,
      storage_template      => $storage_template,
      tls_allowed_cn        => $tls_allowed_cn,
      tls_ca_cert           => $tls_ca_cert,
      tls_ca_cert_dir       => $tls_ca_cert_dir,
      tls_cert              => $tls_cert,
      tls_key               => $tls_key,
      tls_require           => $tls_require,
      tls_verify_peer       => $tls_verify_peer,
      use_plugins           => $use_plugins,
      use_tls               => $use_tls,
    }
  }

  if $is_client {
    class { 'bacula::client':
      director_server   => $director_server_real,
      director_password => $director_password,
      plugin_dir        => $plugin_dir_real,
      tls_allowed_cn    => $tls_allowed_cn,
      tls_ca_cert       => $tls_ca_cert,
      tls_ca_cert_dir   => $tls_ca_cert_dir,
      tls_cert          => $tls_cert,
      tls_key           => $tls_key,
      tls_require       => $tls_require,
      tls_verify_peer   => $tls_verify_peer,
      use_plugins       => $use_plugins,
      use_tls           => $use_tls,
    }
  }

  if $manage_console {
    class { 'bacula::console':
      console_template  => $console_template,
      director_password => $director_password,
      director_server   => $director_server_real,
      tls_ca_cert       => $tls_ca_cert,
      tls_ca_cert_dir   => $tls_ca_cert_dir,
      tls_cert          => $tls_cert,
      tls_key           => $tls_key,
      tls_require       => $tls_require,
      tls_verify_peer   => $tls_verify_peer,
      use_tls           => $use_tls,
    }
  }

  if $manage_bat {
    class { 'bacula::console::bat':
    }
  }
}
