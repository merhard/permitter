require 'rubygems'
require 'bundler/setup'

ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require 'permitter'
require 'permitter/matchers'
require 'action_controller'
require 'factory_girl'
require 'rspec/rails'
require 'rspec/autorun'
require 'pry'

FactoryGirl.find_definitions



RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
  config.include FactoryGirl::Syntax::Methods
  config.use_transactional_fixtures = true
end
