require "bundler/capistrano"

#load "config/recipes/base"
#load "config/recipes/nginx"
#load "config/recipes/unicorn"
#load "config/recipes/sqlite"
#load "config/recipes/nodejs"
#load "config/recipes/rbenv"
#load "config/recipes/check"

server "173.246.40.9", :web, :app, :db, primary: true

set :user, "apps"
set :application, "carrie.marczal.com"
set :deploy_to, "/home/#{user}/rails_apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "apps@173.246.40.9:/home/apps/repos/carrie.marczal.com.git"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases

namespace :deploy do
  namespace :assets do
    desc "Precompile assets on local machine and upload them to the server."
    task :precompile, roles: :web, except: {no_release: true} do
      run_locally "bundle exec rake assets:precompile"
      find_servers_for_task(current_task).each do |server|
        run_locally "rsync -vr --exclude='.DS_Store' public/assets #{user}@#{server.host}:#{shared_path}/"
      end
    end
  end
end
