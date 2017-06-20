# frozen_string_literal: true
# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'

if ENV['RAILS_ENV'] == 'test'
  require 'simplecov'
  SimpleCov.start 'rails'
end

require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'

# ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!

  require 'database_cleaner'
  config.before(:suite) do
    ActiveRecord::Base.establish_connection Rails.env.to_sym
    DatabaseCleaner.clean_with :truncation
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    ActiveRecord::Base.establish_connection Rails.env.to_sym
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  config.after(:each) do
    ActiveRecord::Base.establish_connection Rails.env.to_sym
    DatabaseCleaner.clean
  end
end
