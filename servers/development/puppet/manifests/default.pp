
#
# START: Added to make sure apt-get update runs before anything else
#

Exec { path => ['/usr/bin'] }    

@exec { 'sudo apt-get update':
   tag => foo_update
}

Exec <| tag == foo_update |> -> Package <| |>

#
# END: Added to make sure apt-get update runs before anything else
#


# Install RVM
class { '::rvm': }

# Install Ruby 2.2.2
rvm_system_ruby {
  'ruby-2.2.2':
    ensure      => 'present',
    default_use => true,
}

# Install Bundler
rvm_gem {
  'bundler':
    name         => 'bundler',
    ruby_version => 'ruby-2.2.2',
    ensure       => latest,
    require      => Rvm_system_ruby['ruby-2.2.2'];
}

# Setup directory for nginx vhost
file { ["/var/www/",
        "/var/www/app",
        "/var/www/app/releases",
        "/var/www/app/shared"]:
    ensure => "directory",
    owner => "vagrant",
    group => "vagrant",
}

# Add environment variables here
file { '/var/www/app/shared/.env':
  ensure => 'present',
  content => 'TEST_VAR=abc',
}

# Install nginx and passenger
class { 'nginx':
  package_name => 'nginx-extras',
  package_source  => 'passenger',
  http_cfg_append => {
    'passenger_root' => '/usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini',
  }
}

# Setup vhost for nginx w/ passenger
nginx::resource::vhost { 'rails-dev-vm.local':
  www_root => '/var/www/app/current/public',
  vhost_cfg_append => {
    'passenger_enabled' => 'on',
    'passenger_ruby'    => '/usr/local/rvm/gems/ruby-2.2.2/wrappers/ruby',
  },
  passenger_env_var  => {
    'RAILS_ENV'   => 'development'
  },
}

# Install Postgres
class { 'postgresql::server': 
  postgres_password          => 'AppDbPassw0rd!',
  ip_mask_allow_all_users    => '0.0.0.0/0',
  listen_addresses           => '*',
}

# Setup DB
postgresql::server::db { 'app_db':
  user     => 'app_user',
  password => postgresql_password('app_user', 'AppDbPassw0rd!'),
}

# Install develop libs (required for pg gem)
class { 'postgresql::lib::devel': }

exec { "install_ruby_dev":
  command => "sudo apt-get -y install ruby1.9.1-dev",
}

