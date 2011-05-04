Given(/^a new Rails app$/) do
  FileUtils.rm_rf "tmp/rails_app"
  FileUtils.mkdir_p("tmp")
  system("rails new tmp/rails_app").should be_true
  system("ln -s ../../../lib/generators tmp/rails_app/lib/generators").should be_true
  @current_directory = File.expand_path("tmp/rails_app")
end

Given %{a new migrated Rails app} do
  # Don't delete the rails app
  FileUtils.mkdir_p("tmp")
  system("rails new tmp/rails_app").should be_true
  system("ln -s ../../../lib/generators tmp/rails_app/lib/generators").should be_true
  @current_directory = File.expand_path("tmp/rails_app")
  When %{I run "rails g my_zipcode_gem:models"}
  Then %{I should successfully run "rake db:migrate"}
end
