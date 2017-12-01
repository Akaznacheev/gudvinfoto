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

task :remote_environment do
  invoke :'rbenv:load'
  command %[ export PATH="$PATH:$HOME/.rbenv/shims" ]
end

set :delayed_job, 'bin/delayed_job'
set :delayed_job_pid_dir, 'pids'
set :delayed_job_processes, 1
set :delayed_job_additional_params, ''
set :shared_dirs, fetch(:shared_dirs, []).push(fetch(:delayed_job_pid_dir))

namespace :delayed_job do
  desc 'Stop delayed_job'
  task stop: :remote_environment do
    comment 'Stop delayed_job'
    in_path(fetch(:current_path)) do
      command "RAILS_ENV='#{fetch(:rails_env)}' #{fetch(:delayed_job)} #{fetch(:delayed_job_additional_params)} stop --pid-dir='#{fetch(:shared_path)}/#{fetch(:delayed_job_pid_dir)}'"
    end
  end

  desc 'Start delayed_job'
  task start: :remote_environment do
    comment 'Start delayed_job'
    in_path(fetch(:current_path)) do
      command "RAILS_ENV='#{fetch(:rails_env)}' #{fetch(:delayed_job)} #{fetch(:delayed_job_additional_params)} start -n #{fetch(:delayed_job_processes)} --pid-dir='#{fetch(:shared_path)}/#{fetch(:delayed_job_pid_dir)}'"
    end
  end

  desc 'Restart delayed_job'
  task restart: :remote_environment do
    comment 'Restart delayed_job'
    in_path(fetch(:current_path)) do
      command "RAILS_ENV='#{fetch(:rails_env)}' #{fetch(:delayed_job)} #{fetch(:delayed_job_additional_params)} restart -n #{fetch(:delayed_job_processes)} --pid-dir='#{fetch(:shared_path)}/#{fetch(:delayed_job_pid_dir)}'"
    end
  end

  desc 'delayed_job status'
  task status: :remote_environment do
    comment 'Delayed job Status'
    in_path(fetch(:current_path)) do
      command "RAILS_ENV='#{fetch(:rails_env)}' #{fetch(:delayed_job)} #{fetch(:delayed_job_additional_params)} status --pid-dir='#{fetch(:shared_path)}/#{fetch(:delayed_job_pid_dir)}'"
    end
  end
end

task setup: :remote_environment do
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

task deploy: :remote_environment do
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
