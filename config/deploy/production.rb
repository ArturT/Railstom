app_host = Figaro.env.capistrano_app_host_production

role :web, app_host # Your HTTP server, Apache/etc
role :app, app_host # This may be the same as your `Web` server
role :db,  app_host, :primary => true # This is where Rails migrations will run

set :rails_env, 'production'
set :deploy_to, "#{Figaro.env.capistrano_deploy_to}#{application}-#{rails_env}"
