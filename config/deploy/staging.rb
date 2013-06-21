app_host = Figaro.env.capistrano_app_host_staging

role :web, app_host # Your HTTP server, Apache/etc
role :app, app_host # This may be the same as your `Web` server
role :db,  app_host, :primary => true # This is where Rails migrations will run

set :rails_env, 'staging'
set :deploy_to, "#{Figaro.env.capistrano_deploy_to}#{application}-#{rails_env}"

namespace :deploy do
  desc "Overwrite robots.txt if we are not deploying to production environment"
  task :overwrite_robotstxt do
    run "echo \"User-Agent: *\\nDisallow: /\" > #{release_path}/public/robots.txt"
  end
end

after 'deploy:update_code', 'deploy:overwrite_robotstxt'
