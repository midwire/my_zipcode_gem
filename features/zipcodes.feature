Feature: My Zipcode Gem
  In order to manage zipcode resources
  As a rails developer
  I want to generate models for zipcode, county and state, and populate their tables

  Scenario: Generate models and migration for zipcode, county and state
    Given a new Rails app
    Then I should see "my_zipcode_gem:models" when running "rails g"
    When I run "rails g my_zipcode_gem:models"
    Then I should see the following files
      | app/models/zipcode.rb    |
      | app/models/state.rb      |
      | app/models/county.rb     |
      | lib/tasks/zipcodes.rake  |
      | db/migrate               |
    And I should see "gem "mocha", :group => :test" in file "Gemfile"
    And I should successfully run "rake db:migrate"

  Scenario: Update data for zipcodes, counties and states tables
    Given a new migrated Rails app
    Then I should successfully run "rake zipcodes:update"
    And I should see 51 records in the "states" table
    And I should see 3142 records in the "counties" table
    And I should see 42366 records in the "zipcodes" table
