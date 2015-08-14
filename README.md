This project provides a simple Rails project and a development environment that includes a VM with nginx, passenger, and postgres.

# Getting Started
* From servers/development directory, provision the VM and deploy the project using the following command:
```
vagrant up && cd ../../ && bundle install && cap development vagrant:deploy
```
* Verify the installation by visiting http://192.168.200.100 and http://192.168.200.100/test/index

# Shared directories
* /project : Maps to project root directory.
* /vagrant : Maps to servers/web-server. Default provided by Vagrant.

# Config Files
* Puppet: servers/development/puppet/manifests/default.pp
* Vagrant: servers/development/Vagrantfile
* Database: config/database.yml
* Deployment:
  * config/deploy.rb
  * config/deploy/development.rb
* Capistrano: Capfile

# Access VM
To SSH to the VM, run the following command from the servers/development directory.
```
vagrant ssh
```

# Reload VM
The following command restarts the VM and updates the VM with any changes made to Vagrantfile.
```
vagrant reload
```

# Log files
* /var/log/nginx/error.log 
* /var/log/nginx/access.log 

# Deploy Workspace to Vagrant VM
Using the following command, you can deploy your workspace to the VM.
```
cap development vagrant:deploy
```
Running this command will copy the contents of your project workspace to /var/www/app/releases/local, run 'bundle install', execute DB migrations and seeding, and restart passenger.

# Add New Puppet Module
If you wish to add a new Puppet module, you can use the following steps.

* SSH to VM.
```
vagrant ssh
```
* Install a puppet module to the puppet modules directory.
```
puppet module install -i /vagrant/puppet/modules <module-name>
```
* Update servers/development/puppet/manifests/default.pp to include the module.
* From servers/development, run the provision command to install the module.
```
vagrant provision
```

# Connecting to the DB
You can connect to the DB from your computer using the following connection properties.

* Hostname: localhost
* Port: 15432
* Database: app_db
* Username: app_user
* Password: AppDbPassw0rd!