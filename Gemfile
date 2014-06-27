source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.2'


################################################################################
# Database stuff
gem 'mysql2'
gem 'foreigner'


################################################################################
# JS stuff
# Use jquery as the JavaScript library
gem 'jquery-rails'

# http://rubydoc.info/gems/jquery-ui-rails/1.0.0/frames
gem 'jquery-ui-rails'

#gem 'jquery_datepicker'

# https://github.com/kostia/jquery-minicolors-rails
#gem 'jquery-minicolors-rails'

#gem 'select2-rails'

# rails 4 supported
gem 'i18n-js', github: 'fnando/i18n-js', branch: 'rewrite', ref: '4e5c525ff6e1ec4d3449852746fa5651a0577d68'

gem 'angularjs-rails'
gem 'ng-rails-csrf'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'


################################################################################
# App configuration stuff
gem 'figaro'
gem 'highline', require: false


################################################################################
# Views stuff
gem 'haml-rails'

gem 'devise'
gem 'devise-async'
gem 'devise-i18n-views'

# twitter bootstrap
#gem 'twitter-bootstrap-rails', :git => 'git://github.com/seyhunak/twitter-bootstrap-rails.git'

gem 'font-awesome-rails'

# simple form
gem 'simple_form'

gem 'kaminari'
#gem 'bootstrap-kaminari-views'

gem 'high_voltage'

################################################################################
# Deployment stuff
gem 'capistrano', '~> 2.15'
gem 'capistrano-ext'
gem 'rvm-capistrano'
gem 'whenever', require: false


################################################################################
# Other
gem 'awesome_print'

gem 'draper'

gem 'dependor'

# omniauth with google openid
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-openid'

gem 'fb_graph'

gem 'formtastic', github: 'justinfrench/formtastic'
gem 'activeadmin', github: 'gregbell/active_admin'

# uncomment if you need them
#gem 'cancan'
#gem 'rolify'

gem 'validates_email_format_of'

gem 'carrierwave'
gem 'mini_magick'

# if you require 'sinatra' you get the DSL extended to Object
gem 'sinatra', require: nil
gem 'sidekiq', '~> 2.17.7'
gem 'sidekiq-failures', '~> 0.3.0'

gem 'activerecord-session_store', github: 'rails/activerecord-session_store'


################################################################################
# Gems used only for assets and not required
# in production environments by default.
gem 'less-rails'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

gem 'non-stupid-digest-assets'

gem 'zurb-foundation'
gem 'foundation-icons-sass-rails'

gem 'execjs'
gem 'libv8'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', '~> 0.12.0', platforms: :ruby

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
gem 'ngmin-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

# To use debugger
# gem 'debugger'


################################################################################
# Groups
group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development do
  gem 'rename'
  gem 'rb-inotify', require: false
  gem 'rb-fsevent', require: false
  gem 'rb-fchange', require: false
  gem 'terminal-notifier-guard', require: false
  gem 'pry-rails'
  gem 'immigrant'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'certified'
  gem 'meta_request'
  gem 'rails_best_practices', require: false
  gem 'foreman'
end

group :development, :test do
  gem 'bullet'
  gem 'thin'
  gem 'rspec-rails'
  gem 'rspec-its'
  gem 'rspec-activemodel-mocks'
  gem 'rspec-collection_matchers'
  gem 'jasmine-rails', '~> 0.5.6'
  gem 'guard-jasmine'
  gem 'factory_girl_rails'
  gem 'quiet_assets'
  gem 'ffaker'
  gem 'forgery'
  gem 'brakeman', require: false
  gem 'byebug'
end

group :test do
  #gem 'rb-fsevent', require: false if RUBY_PLATFORM =~ /darwin/i
  gem 'spork-rails'
  gem 'guard-bundler'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'simplecov', require: false
  gem 'simplecov-rcov', require: false
  gem 'coveralls', require: false
  gem 'database_cleaner'
  gem 'capybara'
  gem 'capybara-angular'
  gem 'selenium-webdriver'
  gem 'poltergeist'
  gem 'rspec-sidekiq'
  gem 'timecop'
  gem 'json_spec'
  gem 'shoulda-matchers'
end

group :production do
  gem 'unicorn'
end
