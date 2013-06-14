# Railstom

Rails Custom



# App configuration

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


## Code coverage

To generate a fresh code coverage report in `coverage` directory, run:

    $ SIMPLECOV=1 RCOV=1 rspec spec

