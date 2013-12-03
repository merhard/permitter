# require "sqlite3"
# require "active_record"
# require 'active_support/all'
# require 'matchers'
require 'permitter'
require 'permitter/matchers'
require 'pry'

require File.expand_path("../dummy/config/environment.rb",  __FILE__)

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
end
