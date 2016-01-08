require 'cucumber'
require 'rspec'
require 'rails'
require 'active_record'

ENV["RAILS_ENV"] = "test"

Before do
  # FileUtils.rm_rf "tmp/rails_app"
end
