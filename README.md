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

### Basic

Set your default template engine:

    # config/application.rb
    config.generators do |g|
      # use one of those: :erb, :haml, :slim
      g.template_engine :slim
    end


### Travis CI

Speed up Travis CI builds by caching the bundle to ftp ([based on s3 example](https://gist.github.com/matiaskorhonen/5203327)).

Edit `.travis.yml` if you like.

In development run:

    $ gem install travis

Log into Travis from inside your project respository directory:

    $ travis login --auto

Encrypt your ftp credentials inside the double quotes.
Remember to create sudomain ftp-railstom in your example.com domain where you'll be able to store archived bundle.
`CI_FTP_URL` is a url which will be used to download archived bundle tgz file.

    $ travis encrypt CI_FTP_URL="ftp-railstom.example.com" CI_FTP_HOST="ftp.example.com" CI_FTP_USER="YOUR_FTP_USER" CI_FTP_PASS="YOUR_FTP_PASSWORD"

Put secure token in env.global.secure in `.travis.yml`.

*Notice:* Last generated secure token must be in `.travis.yml`. All previous tokens will be invalid.


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
