# Railstom

[![Build Status](https://travis-ci.org/ArturT/Railstom.png?branch=master)](https://travis-ci.org/ArturT/Railstom)
[![Coverage Status](https://coveralls.io/repos/ArturT/Railstom/badge.png)](https://coveralls.io/r/ArturT/Railstom)
[![Dependency Status](https://gemnasium.com/ArturT/Railstom.png)](https://gemnasium.com/ArturT/Railstom)
[![Code Climate](https://codeclimate.com/github/ArturT/Railstom.png)](https://codeclimate.com/github/ArturT/Railstom)

Rails Custom



# App configuration

## Dependencies

### Libs

#### Linux

Install ImageMagick (for photo processing):

    $ sudo apt-get install imagemagick

#### MacOS

    $ brew install v8
    $ brew install imagemagick

### Redis

#### MacOS X

    $ brew install redis
    (...)
    ==> Caveats
    If this is your first install, automatically load on login with:
        mkdir -p ~/Library/LaunchAgents
        cp /usr/local/Cellar/redis/2.6.2/homebrew.mxcl.redis.plist ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.redis.plist

    If this is an upgrade and you already have the homebrew.mxcl.redis.plist loaded:
        launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.redis.plist
        cp /usr/local/Cellar/redis/2.6.2/homebrew.mxcl.redis.plist ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.redis.plist

      To start redis manually:
        redis-server /usr/local/etc/redis.conf

      To access the server:
        redis-cli
    ==> Summary

#### Debian

    $ sudo apt-get install redis-server

Will run on system boot. Use redis-cli to manage.


## Basic

* copy `.ruby-version.example` to `.ruby-version`
* copy `.rspec.example` to `.rspec`
* copy `config/database.yml.example` to `config/database.yml` and edit
* copy `config/application.yml.example` to `config/application.yml` and edit

Create databases and run:

    $ rake db:create
    $ rake db:schema:load
    $ RAILS_ENV=test rake db:schema:load


Rename application:

    $ rails g rename:app_to YourAppName


Set your default metadata in `en.yml` and `pl.yml`:

    # config/locale/en.yml
    layouts:
      application:
        metadata:
          title: 'Railstom'
          description: ''
          keywords: ''


## Additional configuration

### Template engine

Set your default template engine:

    # config/application.rb
    config.generators do |g|
      # use one of those: :erb, :haml, :slim
      g.template_engine :slim
    end


### I18n-js

Edit `config/i18n-js.yml` to add a new translation namespace for [I18n-js](https://github.com/fnando/i18n-js#configuration).


### AngularJS templates

Put your angular template `your_template_name.html.erb` in `app/views/pages/templates/` if you need use erb/slim/haml. Access to this template is through the route `/templates/your_template_name`.

If you use only html without erb/slim/haml then put your angular template `your_template_name.html` in `/public/templates/`.


### HighVoltage

Put your page `contact.html.erb` in `app/views/pages/` then it will be accessible via `page_path(:locale, 'contact')` or `default_page_path('contact')` => `/:locale/pages/contact`.

You can also split `contact.html.erb` for separate language. Put it here `app/views/pages/en/` and `app/views/pages/pl/` etc.
Then you can use helper to access this page: `locale_page_path(:locale, 'contact')` or `default_locale_page_path('contact')` => `/:locale/locale_pages/contact`.


## Tools

### Sidekiq

To run sidekiq:

    $ bundle exec sidekiq -C config/sidekiq.yml


### MailCatcher

To run mailcatcher:

    $ mailcatcher
    Starting MailCatcher
    ==> smtp://127.0.0.1:1025
    ==> http://127.0.0.1:1080
    *** MailCatcher runs as a daemon by default. Go to the web interface to quit.


## Code coverage

To generate a fresh code coverage report in `coverage` directory, run:

    $ SIMPLECOV=1 RCOV=1 rspec spec


## Testing

### Features specs

Example how to run js spec and how to open it in browser:

    # spec/features/home_feature_spec.rb
    feature 'Home Page' do
      before { visit root_path }

      # run with webkit without opening browser
      scenario 'should have text Hello', :js do
        page.should have_content 'Hello'
      end

      # run with selenium in firefox
      scenario 'should have text World', :selenium do
        page.should have_content 'World'
      end
    end



# Deploy

## Server config files

    /script/examples/unicorn.cfg.rb
    /script/examples/railstom-production-unicorn

    /script/examples/vhost/railstom-production.com
    /script/examples/vhost/www.railstom-production.com


## First deploy

    $ cap production deploy
    $ cap production deploy:migrate
    $ cap production deploy:start


## Tips

    $ cap production deploy:start
    $ cap production deploy:restart
    $ cap production deploy:stop

    $ cap production sidekiq:start
    $ cap production sidekiq:restart
    $ cap production sidekiq:stop


Run a task on a remote server:

    $ cap staging help:rake:invoke task=a_certain_task
