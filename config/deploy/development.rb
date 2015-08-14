server '192.168.200.100', user: 'vagrant', roles: %w{app, web, db}, :primary => true,
  ssh_options: {
    user: 'vagrant', # overrides user setting above
    keys: %w(servers/development/.vagrant/machines/default/virtualbox/private_key),
    forward_agent: false,
    auth_methods: %w(publickey password)
  }