require 'capistrano_colors'

set :bundle_cmd, '. /etc/profile && bundle'
require "bundler/capistrano"

require 'yaml'
require 'erb'

require File.expand_path(File.join('config', 'initialisers', '00_config'))

$NESTA_CONFIG = Hashie::Mash.new YAML.load_file(File.expand_path('../config.yml', __FILE__))

set :application, "Green Worm"
set :repository, $CONFIG.deploy.repo

set :scm, :git
set :scm_verbose, true

set :deploy_to, "#{$CONFIG.deploy.base}/#{$APP_CONFIG.name}"
set :deploy_via, :remote_cache

set :keep_releases, 3
set :use_sudo, false
set :normalize_asset_timestamps, false

set :user, $CONFIG.deploy.ssh_user
ssh_options[:port] = $CONFIG.deploy.ssh_port
ssh_options[:keys] = eval($CONFIG.deploy.ssh_key)
ssh_options[:forward_agent] = true

role :app, $CONFIG.deploy.ssh_host

after "deploy:update", "index:recreate", "deploy:cleanup"
after "deploy:setup", "deploy:more_setup"

before "deploy:create_symlink",
  "deploy:configs",
  "attachments:sync",
  "attachments:symlink",
  "nginx:setup",
  "nginx:reload"

namespace :deploy do

  desc 'More setup.. ensure necessary directories exist, etc'
  task :more_setup do
    run "mkdir -p #{shared_path}/config #{shared_path}/attachments #{shared_path}/index"
  end

  desc 'Deploy necessary configs into shared/config'
  task :configs do
    put $NESTA_CONFIG.to_yaml, "#{shared_path}/config/config.yml"
    put $CONFIG.reject { |x| x == 'deploy' }.to_yaml, "#{shared_path}/config/deploy.yml"
    run "ln -nfs #{shared_path}/config/config.yml #{release_path}/config/config.yml"
    run "ln -nfs #{shared_path}/config/deploy.yml #{release_path}/config/deploy.yml"
    put File.read('config/newrelic.yml'), "#{shared_path}/config/newrelic.yml"
    run "ln -nfs #{shared_path}/config/newrelic.yml #{release_path}/config/newrelic.yml"
  end
end

namespace :attachments do

  desc 'Sync attachments'
  task :sync do
    system "rake attachments:sync"
  end

  desc 'Symlink attachments'
  task :symlink do
    run "ln -nfs #{shared_path}/attachments #{release_path}/content/"
    run "ln -nfs #{shared_path}/index #{release_path}/"
  end
end

namespace :index do

  desc 'Recreate index'
  task :recreate do
    run ". /etc/profile ; cd #{current_release} ; bundle exec rake search:index"
  end
end

namespace :nginx do

  desc 'Reload nginx'
  task :reload do
    sudo 'service nginx reload'
  end

  desc 'Setup nginx site configuration'
  task :setup do
    nginx_config = $CONFIG.deploy.nginx

    nginx_base_dir = "/etc/nginx"
    nginx_available_dir = "#{nginx_base_dir}/sites-available"
    nginx_enabled_dir = "#{nginx_base_dir}/sites-enabled"
    nginx_available_file = "#{nginx_available_dir}/#{nginx_config.app_name}"

    put nginx_site_config(nginx_config), nginx_available_file
    run "ln -nsf #{nginx_available_file} #{nginx_enabled_dir}/"
  end
end

def nginx_site_config config
  template = ERB.new(File.read("config/nginx-#{config.app_name}.erb"))
  template.result(binding)
end
