require 'rubygems'
require 'knapsack'

Knapsack::Adapters::RspecAdapter.bind

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
      add_group 'Presenters', 'app/presenters'
      add_group 'Repositories', 'app/repositories'
      add_group 'Services', 'app/services'
      add_group 'Uploaders', 'app/uploaders'
      add_group 'Validators', 'app/validators'
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
require 'dependor/shorty'
require 'dependor/rspec'
require 'factory_girl'
require 'sidekiq'
require 'capybara/poltergeist'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join('spec/support/**/*.rb')].each {|f| require f}

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  #config.raise_errors_for_deprecations!

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Enable only the newer, non-monkey-patching expect syntax.
    # For more details, see:
    #   - http://teaisaweso.me/blog/2013/05/27/rspecs-new-message-expectation-syntax/
    mocks.syntax = :expect

    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended.
    mocks.verify_partial_doubles = true
  end

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

  # infer an example group's spec type from the file location
  config.infer_spec_type_from_file_location!

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

  config.before(type: :feature) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
    Capybara.current_driver = :selenium if RSpec.current_example.metadata[:selenium]

    # https://github.com/mperham/sidekiq/wiki/Testing#testing-worker-queueing-fake
    if RSpec.current_example.metadata[:sidekiq]
      load 'sidekiq/testing.rb'
      Sidekiq::Testing.fake!
    end

    # https://github.com/mperham/sidekiq/wiki/Testing#testing-workers-inline
    if RSpec.current_example.metadata[:sidekiq_inline]
      require 'sidekiq/testing'
      Sidekiq::Testing.inline!
    end
  end

  config.after(:each) do
    DatabaseCleaner.clean
    Capybara.use_default_driver if RSpec.current_example.metadata[:selenium]

    if RSpec.current_example.metadata[:sidekiq] || RSpec.current_example.metadata[:sidekiq_inline]
      Sidekiq::Testing.disable!
    end
  end

  config.after(:all) do
    FileUtils.rm_rf(Dir["#{Rails.root}/tmp/test/carrierwave"])
  end

  # Default js driver
  Capybara.javascript_driver = :poltergeist

  config.include Devise::TestHelpers, type: :view
  config.include Devise::TestHelpers, type: :controller

  config.extend ControllerMacros, type: :controller

  config.include CustomMatchers
  config.include CarrierWave::Test::Matchers

  config.include LoginFeatureHelper, type: :feature
  config.include LoginRequestHelper, type: :request

  config.include JsonSpec::Helpers
end

CarrierWave.configure do |config|
  config.root = "#{Rails.root}/tmp/test/carrierwave"
end
