source 'https://rubygems.org'

gem 'rails', '3.2.13'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'


################################################################################
# Database stuff
gem 'mysql2'


################################################################################
# JS stuff
gem 'jquery-rails'

# http://rubydoc.info/gems/jquery-ui-rails/1.0.0/frames
#gem 'jquery-ui-rails'

#gem 'jquery_datepicker'

# https://github.com/kostia/jquery-minicolors-rails
#gem 'jquery-minicolors-rails'

#gem 'select2-rails'

gem 'i18n-js'

gem 'angularjs-rails'


################################################################################
# App configuration stuff
gem 'figaro'


################################################################################
# Views stuff
gem 'haml-rails'
gem 'slim-rails'

gem 'devise'
gem 'devise-async'
gem 'devise-i18n-views'

# twitter bootstrap
#gem 'twitter-bootstrap-rails', :git => 'git://github.com/seyhunak/twitter-bootstrap-rails.git'

# simple form
gem 'simple_form'

gem 'kaminari'
#gem 'bootstrap-kaminari-views'

gem 'high_voltage'

################################################################################
# Deployment stuff
gem 'capistrano'
gem 'capistrano-ext'
gem 'rvm-capistrano'
gem 'whenever', :require => false


################################################################################
# Other
gem 'awesome_print'

gem 'draper'

# omniauth with google openid
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-openid'

gem 'activeadmin'

gem 'cancan'
gem 'rolify'

gem 'mail_form'
gem 'validates_email_format_of'

gem 'carrierwave'
gem 'mini_magick'

# if you require 'sinatra' you get the DSL extended to Object
gem 'sinatra', :require => nil
gem 'sidekiq'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'less-rails'
  gem 'coffee-rails', '~> 3.2.1'

  gem 'compass-rails'
  gem 'zurb-foundation'

  gem 'execjs'
  gem 'libv8'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# To use debugger
# gem 'debugger'

group :development do
  gem 'rename'
  gem 'rb-inotify', :require => false
  gem 'rb-fsevent', :require => false
  gem 'rb-fchange', :require => false
  gem 'terminal-notifier-guard', :require => false
  gem 'pry-rails'
  gem 'foreigner'
  gem 'immigrant'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'certified'
  gem 'mailcatcher'
  gem 'meta_request', '0.2.1'
end

group :development, :test do
  gem 'bullet'
  gem 'thin'
  gem 'rspec-rails'
  gem 'jasmine-rails'
  gem 'factory_girl_rails'
  gem 'quiet_assets'
  gem 'shoulda-matchers'
  gem 'ffaker'
  gem 'forgery'
end

group :test do
  #gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i
  gem 'spork'
  gem 'guard-bundler'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'simplecov', :require => false
  gem 'simplecov-rcov', :require => false
  gem 'database_cleaner'
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'selenium-webdriver'
end

group :production do
  gem 'unicorn'
end
