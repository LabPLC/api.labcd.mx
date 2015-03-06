# config valid only for current version of Capistrano
lock '3.3.5'


set :application, 'labcdmx'
set :repo_url, 'git@github.com:labplc/api.labcd.mx.git'

set :deploy_to, "/home/juannpablo/#{fetch(:application)}"
set :tmp_dir, "/home/juannpablo/tmp"

set :linked_files, %w{config/database.yml config/secrets.yml .env}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :bundle_binstubs, nil

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
  after "deploy:finished", "airbrake:deploy"

end
