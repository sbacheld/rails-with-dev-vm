# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'rails-with-dev-vm'
set :rvm_type, :system
set :rvm_ruby_version, '2.2.2'
set :rvm_bin_path, "/usr/local/rvm/bin"
set :deploy_to, '/var/www/app'

# Points to the location of the project root on the Vagrant VM (for development deployments)
set :local_project_root, '/project'

set :rails_env, "development"

# Deploys to the development Vagrant VM
namespace :vagrant do 
  task :deploy do
    on roles(:all) do |host|
      local_project_path = fetch(:local_project_root)

      set :release_path, "#{deploy_to}/releases/local"

      info "Deploying to Vagrant Development VM on #{host} to #{release_path}"

      # Copy local project contents to a release directory
      execute 'rm', "-rf #{release_path}"
      execute 'mkdir', "-p #{release_path}"
      execute 'cp', "-R #{local_project_path}/. #{release_path}"

      # Run bundle and migrate tasks
      with rails_env: fetch(:rails_env) do
        within release_path do
          execute :bundle, "install --path #{shared_path}/bundle --without development test --deployment --quiet"
          rake 'db:migrate'
          rake 'db:seed'
        end
      end

      # Set symlink to current version
      execute 'ln', "-s #{release_path} #{release_path}/current"
      execute 'mv', "#{release_path}/current #{deploy_to}"

      # Restart Passenger
      execute 'touch', "#{File.join(current_path,'tmp','restart.txt')}"
    end
  end
end