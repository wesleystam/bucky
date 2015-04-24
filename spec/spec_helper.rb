$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'bucky'
require "pry"
require "webmock/rspec"

Dir[File.dirname(__FILE__) + "/support/**.rb"].each{|support_file| require support_file }

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.mock_with :rspec
end
