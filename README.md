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


## Additional configuration

Set your default template engine:

    # config/application.rb
    config.generators do |g|
      # use one of those: :erb, :haml, :slim
      g.template_engine :slim
    end


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
