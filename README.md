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

[PhantomJS](http://phantomjs.org/download.html)

#### MacOS

    $ brew install v8
    $ brew install imagemagick
    $ brew install phantomjs

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
* copy `.rspec.example` to `.rspec` and edit
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

### TODO informations

Run `rake notes` to find useful TODO informations inside of the app.


### Database pool

In `config/database.yml` file the `pool` setting is equal 25 because sidekiq creates 25 processors. More info: [Sidekiq Concurrency](https://github.com/mperham/sidekiq/wiki/Advanced-Options#concurrency).


### Database populate

You can use [ffaker](https://github.com/stympy/faker) or [forgery](https://github.com/sevenwire/forgery/wiki) gem to populate your database.

To populate db with users run:

    $ bundle exec rake db:populate:users


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


### Cache store

Perform caching is enabled in `config/environments/development.rb`:

    config.action_controller.perform_caching = true


### Turbolinks

[Turbolinks](https://github.com/rails/turbolinks/) are enabled by default. If you like to turn them off please add to your body `data-no-turbolink`:

    # app/views/layouts/application.html.erb
    <body data-no-turbolink>


## Tools

### Foreman

Using [foreman](https://github.com/ddollar/foreman) you can declare the various processes that are needed to run your application using a `Procfile`.

    $ foreman start

Foreman will start mailcatcher, sidekiq, guard and zeus.

#### Tips

* If you already running mailcatcher please kill it before you start foreman.

* Use `zeus server` in order to run rails server faster.


### Sidekiq

To run sidekiq:

    $ bundle exec sidekiq -C config/sidekiq.yml

[Sidekiq Benchmark](https://github.com/kosmatov/sidekiq-benchmark) adds benchmarking methods to Sidekiq workers.


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


## Tips

### Rails Panel Chrome Extension

You can use [devtools panel for Rails development](https://chrome.google.com/webstore/detail/railspanel/gjpfobpafnhjhbajcjgccbbdofdckggg).


### Rails Best Practices

[rails_best_practices](https://github.com/railsbp/rails_best_practices) is a code metric tool to check the quality of rails codes.

Run:

    $ rails_best_practices -f html .


## Pagination with Kaminari

[Creating friendly URLs and caching](https://github.com/amatsuda/kaminari#creating-friendly-urls-and-caching).
Another advantage of this approach is that you can switch language and keep page number in url.


## Testing

### Rspec

Basic way to run specs:

    $ rspec spec

Run specs via guard. If you change some code or spec file then proper spec will run automatically. First start foreman which runs all services:

    $ foreman start
    // wait until loaded and press Enter to run all specs

Run specific spec via `zeus`:

    $ zeus rspec spec/models/user_spec.rb

    // run spec at line 8
    $ zeus rspec spec/models/user_spec.rb:8

    // run specs with flag railstom
    $ zeus rspec --tag=railstom spec


### Jasmine

Run jasmine specs:

    $ rake spec:javascript

    // or use zeus to get speed
    $ zeus rake spec:javascript

Run jasmine specs in browser: [http://127.0.0.1:3000/specs](http://127.0.0.1:3000/specs)


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


### Railstom specs

If you don't need specs related to Railstom you can just turn them off. Put this in your `.rspec` file to ignore specs with tag `railstom`.

    # .rspec
    --tag=~railstom


### Sidekiq Testing

Sidekiq provides a few options for testing your workers.

[Testing Worker Queueing](https://github.com/mperham/sidekiq/wiki/Testing#testing-worker-queueing). To enable sidekiq testing for specific spec add flag `sidekiq`.

[Testing Workers Inline](https://github.com/mperham/sidekiq/wiki/Testing#testing-workers-inline). To enable sidekiq testing inline for specific spec add flag `sidekiq_inline`.


# Deploy

## Server config files

    /script/examples/unicorn.cfg.rb
    /script/examples/railstom-production-unicorn

    /script/examples/vhost/railstom-production.com
    /script/examples/vhost/www.railstom-production.com


## First deploy

    $ cap production deploy:setup
    $ cap production deploy:check

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

    $ cap staging do:rake:invoke task=a_certain_task
