This project provides a simple Rails project and a development environment that includes a VM with nginx, passenger, and postgres.

# Getting Started
1. From servers/development directory, run "vagrant up". This will provision the entire VM
2. From project home directory, run "cap development vagrant:deploy". This will load the ruby code onto the VM and run the required migrations.
3. Verify the installation by visiting http://192.168.200.10 and http://192.168.200.10/test

# Shared directories
* /project : Maps to project root directory.
* /vagrant : Maps to servers/web-server. Default provided by Vagrant.

# Access VM
```
vagrant ssh
```

# Reload VM
```
vagrant reload
```

# Log files
* /var/log/nginx/error.log 
* /var/log/nginx/access.log 

# Deploy Workspace to Vagrant VM
Using the following command, you can deploy your workspace to the VM 
```
cap development vagrant:deploy
```

# Add New Puppet Module
If you wish to add a new Puppet module, you can use the following steps.

1. SSH to VM
```
vagrant ssh
```
2. Install a puppet module to the puppet modules directory
```
puppet module install -i /vagrant/puppet/modules <module-name>
```
3. Update servers/development/puppet/manifests/default.pp
4. From servers/development, run the provision command
```
vagrant provision
```

# Connecting to the DB
You can connect to the DB using the following connection properties from your own computer.

* Hostname: localhost
* Port: 15432
* Database: app_db
* Username: app_user
* Password: AppDbPassw0rd!