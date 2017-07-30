require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'
require 'mina/nginx'
require 'mina/puma'

set :application_name, 'gudvinfoto'
set :domain, '151.248.117.247'
set :port, '22'
set :user, 'deployer'
set :shared_dirs,  fetch(:shared_dirs, []).push('tmp', 'log', 'public/orders', 'public/downloads', 'public/uploads')
set :shared_files, fetch(:shared_files, []).push('config/puma.rb', 'config/database.yml', 'config/secrets.yml')
set :deploy_to, '/home/deployer/apps/gudvinfoto'
set :repository, 'https://github.com/Akaznacheev/gudvinfoto.git'
set :branch, 'master'
set :forward_agent, true
set :rails_env, 'production'

task :environment do
  invoke :'rbenv:load'
  command %[ export PATH="$PATH:$HOME/.rbenv/shims" ]
end

task setup: :environment do
  command %{mkdir -p "#{fetch(:shared_path)}/log"}
  command %{chmod g+rx,u+rwx "#{fetch(:shared_path)}/log"}

  command %{mkdir -p "#{fetch(:shared_path)}/config"}
  command %{chmod g+rx,u+rwx "#{fetch(:shared_path)}/config"}

  command %{touch "#{fetch(:shared_path)}/config/puma.rb"}
  command %{touch "#{fetch(:shared_path)}/config/database.yml"}
  command %{touch "#{fetch(:shared_path)}/config/secrets.yml"}

  command %{mkdir -p "#{fetch(:shared_path)}/tmp/sockets"}
  command %{chmod g+rx,u+rwx "#{fetch(:shared_path)}/tmp/sockets"}
  command %{mkdir -p "#{fetch(:shared_path)}/tmp/pids"}
  command %{chmod g+rx,u+rwx "#{fetch(:shared_path)}/tmp/pids"}
end

task deploy: :environment do
  deploy do
    comment "Deploying #{fetch(:application_name)} to #{fetch(:domain)}:#{fetch(:deploy_to)}"
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    # command %{#{fetch(:rails)} db:seed}
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'
    invoke :'delayed_job:restart'
    invoke :'puma:phased_restart'
  end
end