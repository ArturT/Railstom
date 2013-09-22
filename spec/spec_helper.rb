require 'rubygems'
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

if defined?(Spork) && ENV['DRB']
  Spork.trap_method Rails::Application::RoutesReloader, :reload!
end

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

  if ENV['COVERALLS']
    require 'coveralls'
    Coveralls.wear!
  end

  if ENV['SIMPLECOV']
    require 'simplecov'
    if ENV['RCOV']
      require 'simplecov-rcov'

      SimpleCov.start 'rails' do
        add_group 'Decorators', 'app/decorators'
        add_group 'Modules', 'app/modules'
        add_group 'Presenters', 'app/presenters'
        add_group 'Services', 'app/services'
        add_group 'Uploaders', 'app/uploaders'
        add_group 'Workers', 'app/workers'
        add_filter 'app/admin'
      end

      class SimpleCov::Formatter::MergedFormatter
        def format(result)
          SimpleCov::Formatter::HTMLFormatter.new.format(result)
          SimpleCov::Formatter::RcovFormatter.new.format(result)
        end
      end

      SimpleCov.formatter = SimpleCov::Formatter::MergedFormatter
      SimpleCov.coverage_dir('coverage')
    else
      SimpleCov.start
    end
  end

  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV['RAILS_ENV'] ||= 'test'
  require File.expand_path('../../config/environment', __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'dependor/shorty'
  require 'dependor/rspec'
  require 'factory_girl'
  require 'sidekiq'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join('spec/support/**/*.rb')].each {|f| require f}

  # Checks for pending migrations before tests are run.
  # If you are not using ActiveRecord, you can remove this line.
  ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

  RSpec.configure do |config|
    # ## Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    config.fixture_path = "#{::Rails.root}/spec/fixtures/"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    # False, because: http://stackoverflow.com/a/9300267
    config.use_transactional_fixtures = false

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false

    # Run specs in random order to surface order dependencies. If you find an
    # order dependency and want to debug it, you can fix the order by providing
    # the seed, which is printed after each run.
    #     --seed 1234
    config.order = 'random'

    # Symbols like [:js] will be treated as metadata keys with a value of `true`
    config.treat_symbols_as_metadata_keys_with_true_values = true

    # FactoryGirl methods
    config.include FactoryGirl::Syntax::Methods

    # Database Cleaner configuration
    config.before(:suite) do
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with(:transaction)
    end

    config.before(:all) do
      # TODO default locale for each spec file
      I18n.locale = :en
    end

    config.before(:type => :feature) do
      DatabaseCleaner.strategy = :truncation
    end

    config.before(:each) do
      DatabaseCleaner.start
      Capybara.current_driver = :selenium if example.metadata[:selenium]
      # https://github.com/mperham/sidekiq/wiki/Testing#testing-worker-queueing
      load 'sidekiq/testing.rb' if example.metadata[:sidekiq]
      # https://github.com/mperham/sidekiq/wiki/Testing#testing-workers-inline
      load 'sidekiq/testing/inline.rb' if example.metadata[:sidekiq_inline]
    end

    config.after(:each) do
      DatabaseCleaner.clean
      Capybara.use_default_driver if example.metadata[:selenium]

      if example.metadata[:sidekiq] || example.metadata[:sidekiq_inline]
        Sidekiq::Client.class_eval do
          singleton_class.class_eval do
            alias_method :raw_push, :raw_push_old
          end
        end
      end
    end

    config.after(:all) do
      FileUtils.rm_rf(Dir["#{Rails.root}/tmp/test/carrierwave"])
    end

    # Default js driver
    Capybara.javascript_driver = :webkit

    config.include Devise::TestHelpers, type: :view
    config.include Devise::TestHelpers, type: :controller

    config.extend ControllerMacros, :type => :controller

    config.include CustomMatchers
    config.include CarrierWave::Test::Matchers

    config.include LoginFeatureHelper, :type => :feature
    config.include LoginRequestHelper, :type => :request

    config.include JsonSpec::Helpers
  end

  CarrierWave.configure do |config|
    config.root = "#{Rails.root}/tmp/test/carrierwave"
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.

  ActiveSupport::Dependencies.clear
  FactoryGirl.reload

  Dir[File.join(File.dirname(__FILE__), '..', 'app', 'helpers', '*.rb')].each do |file|
    require file
  end
end
