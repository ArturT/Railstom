require File.expand_path('../environment',  __FILE__)

# http://gembundler.com/deploying.html
require 'bundler/capistrano'

# https://github.com/capistrano/capistrano/wiki/2.x-Multistage-Extension
require 'capistrano/ext/multistage'

set :whenever_command, 'bundle exec whenever'
set :whenever_environment, defer { stage }
set :whenever_identifier, defer { "#{application}_#{stage}" }
require 'whenever/capistrano'

# docs: https://rvm.io//integration/capistrano/
set :rvm_ruby_string, Figaro.env.capistrano_rvm_ruby_string
#set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,"") # Read from local system

require 'rvm/capistrano'


set :application, Figaro.env.capistrano_app_name
set :repository,  Figaro.env.capistrano_repository

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :branch, ENV['REV'] || ENV['REF'] || ENV['BRANCH'] || ENV['TAG'] || 'master'
set :deploy_via, :remote_cache
set :use_sudo, false
ssh_options[:forward_agent] = true

set :user, Figaro.env.capistrano_user
set :keep_releases, 10

set :stages, %w(staging production)
set :default_stage, 'staging'

namespace :deploy do
  task :start, :roles => :app do
    run "sudo /etc/init.d/#{application}-#{rails_env}-unicorn start"
  end

  task :stop, :roles => :app do
    run "sudo /etc/init.d/#{application}-#{rails_env}-unicorn stop"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    pid = "/tmp/#{application}-#{rails_env}-unicorn.pid"
    run "if [ -e #{pid} ]; then kill -USR2 `cat #{pid}`; fi"
  end

  namespace :services do
    namespace :sidekiq do
      desc "Start Sidekiq"
      task :start, :roles => :app do
        run "sudo /etc/init.d/sidekiq-#{application}-#{rails_env} start"
      end

      desc "Stop Sidekiq"
      task :stop, :roles => :app do
        run "sudo /etc/init.d/sidekiq-#{application}-#{rails_env} stop"
      end

      desc "Restart Sidekiq"
      task :restart, :roles => :app do
        run "sudo /etc/init.d/sidekiq-#{application}-#{rails_env} restart"
      end

      desc "Status of Sidekiq"
      task :status, :roles => :app do
        run "sudo /etc/init.d/sidekiq-#{application}-#{rails_env} status"
      end
    end
  end

  desc "Symlink shared files/directories"
  task :symlink_shared do
    cmd = "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    cmd << " && ln -nfs #{shared_path}/config/application.yml #{release_path}/config/application.yml"
    cmd << " && ln -nfs #{shared_path}/uploads #{release_path}/public"
    cmd << " && ln -nfs #{shared_path}/config/unicorn.cfg.rb #{release_path}/config/unicorn.cfg.rb"
    run cmd
  end

  desc "Copy .ruby-version.example to .ruby-version"
  task :copy_ruby_version_file do
    run "cp #{release_path}/.ruby-version.example #{release_path}/.ruby-version"
  end

  namespace :assets do
    desc "Precompile assets only if it is needed"
    task :precompile, :roles => :web, :except => { :no_release => true } do
      from = source.next_revision(current_revision) rescue nil
      if from.nil? || capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ lib/assets/ app/assets/ | wc -l").to_i > 0
        run "cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile"
      else
        logger.info "No changes on assets. Skipping pre-compilation."
      end
    end

    task :force_precompile, :roles => :web, :except => { :no_release => true } do
      run "cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile"
    end
  end

  namespace :setup_finalize do
    desc "Create shared/uploads directory"
    task :shared_uploads_dir do
      run "mkdir #{shared_path}/uploads"
    end

    desc "Create shared/config directory"
    task :shared_config_dir do
      run "mkdir #{shared_path}/config"
    end

    desc "Copy files to shared/config directory"
    task :copy_files_to_shared_config_dir do
      transfer :up, "config/database.yml", "#{shared_path}/config/database.yml", :via => :scp
      transfer :up, "config/application.yml", "#{shared_path}/config/application.yml", :via => :scp
      transfer :up, "script/examples/unicorn.cfg.rb", "#{shared_path}/config/unicorn.cfg.rb", :via => :scp
    end
  end
end


# timer should have value to avoid crash if timer_start method won't run
timer = Time.now

namespace :do do
  namespace :rake do
    desc "Run a task on a remote server."
    # run like: cap staging do:rake:invoke task=a_certain_task
    task :invoke do
      run("cd #{deploy_to}/current; bundle exec rake #{ENV['task']} RAILS_ENV=#{rails_env}")
    end
  end

  task :uname do
    run "uname -a"
  end

  task :pwd do
    run "pwd"
  end

  task :env do
    run "echo #{rails_env} and deploy to #{deploy_to}"
  end

  task :timer_start do
    timer = Time.now
  end

  task :timer_end do
    timer = Time.at(Time.now - timer).gmtime.strftime('%Hh %Mm %Ss')
    run "echo Timer: #{timer}"
  end
end


before 'deploy:update_code', 'do:timer_start'

after 'deploy:finalize_update', 'deploy:symlink_shared'
after 'deploy:finalize_update', 'deploy:copy_ruby_version_file'

after 'deploy:restart', 'deploy:services:sidekiq:restart'
# if you want to clean up old releases on each deploy uncomment this:
after 'deploy:restart', 'deploy:cleanup'

after 'deploy:cleanup', 'do:timer_end'


# Stop and start services
after 'deploy:stop', 'deploy:services:sidekiq:stop'
after 'deploy:start', 'deploy:services:sidekiq:start'


# after deploy setup
after 'deploy:setup', 'deploy:setup_finalize:shared_uploads_dir'
after 'deploy:setup', 'deploy:setup_finalize:shared_config_dir'
after 'deploy:setup', 'deploy:setup_finalize:copy_files_to_shared_config_dir'
