# Railstom

Rails Custom



# App configuration

* copy `.ruby-version.example` to `.ruby-version`
* copy `config/database.yml.example` to `config/database.yml` and edit
* copy `config/application.yml.example` to `config/application.yml` and edit

Create databases and run:

    $ rake db:create
    $ rake db:schema:load
    $ RAILS_ENV=test rake db:schema:load


Rename application:

    $ rails g rename:app_to YourAppName

