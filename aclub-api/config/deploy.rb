require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'
require 'mina/unicorn'
require 'mina_sidekiq/tasks'

set :repository, 'git@bitbucket.org:occbuu/occbuu.git' #'git@bitbucket.org:ciminuv/aclub-api.git'
set :deploy_to, '/home/deployer/aclub'
set :user, 'deployer'
set :shared_paths, ['config/database.yml', 'config/secrets.yml', 'tmp/sockets', 'tmp/pids', 'log']
set :forward_agent, true

case ENV['to']
  when 'production'
    set :domain, ''#'453.117.842.473'
    set :branch, 'master'
  else
    set :domain, '522.75.138.49'
    set :branch, 'development'
end

set :sidekiq_pid, lambda { "#{deploy_to}/#{shared_path}/tmp/pids/sidekiq.pid" }
set :rvm_path, '/home/deployer/.rvm/bin/rvm'

task :environment do
  invoke :'rvm:use[ruby-2.2.2]'
end

task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/log"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/config"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/tmp/sockets"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/tmp/sockets"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/tmp/pids"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/tmp/pids"]

  queue! %[touch "#{deploy_to}/#{shared_path}/config/database.yml"]
  queue! %[touch "#{deploy_to}/#{shared_path}/config/secrets.yml"]
  queue  %[echo "-----> Be sure to edit '#{deploy_to}/#{shared_path}/config/database.yml' and 'secrets.yml'."]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  to :before_hook do
    # Put things to run locally before ssh
  end
  deploy do
    invoke :'sidekiq:quiet'

    #invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    to :launch do
      invoke :'sidekiq:restart'
      invoke :'unicorn:restart'
      queue 'sudo service nginx restart'
    end
  end
end
