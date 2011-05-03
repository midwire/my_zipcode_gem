require 'open-uri'
require 'fastercsv'
namespace :zipcodes do

  desc "Update states table"
  task :update_states => :environment do
    puts ">>> Begin update of states table..."
    url = "https://github.com/midwire/free_zipcode_data/raw/master/all_us_states.csv"
    data = open(url)
    file = nil
    if data.is_a? StringIO
      file = Tempfile.new('all_us_states.csv')
      file.write(data.read)
      file.flush
      file.close
    else
      file = data
    end
    FasterCSV.foreach(file.path, :headers => true) do |row|
      puts "Updating state: [#{row['name']}]"
      state = State.find_or_initialize_by_abbr(row['abbr'])
      state.update_attribute(:name, row['name'])
    end
    data.close
    puts ">>> End update of states table..."
  end

  desc "Update counties table"
  task :update_counties => :update_states do
    puts ">>> Begin update of counties table..."
    url = "https://github.com/midwire/free_zipcode_data/raw/master/all_us_counties.csv"
    data = open(url)
    file = nil
    if data.is_a? StringIO
      file = Tempfile.new('all_us_counties.csv')
      file.write(data.read)
      file.flush
      file.close
    else
      file = data
    end
    FasterCSV.foreach(file.path, :headers => true) do |row|
      puts "Updating county: [#{row['name']}]"
      # lookup state
      state = State.find_by_abbr!(row['state'])
      county = County.find_or_initialize_by_name_and_state_id(row['name'], state.to_param)
      county.update_attribute(:county_seat, row['county_seat'])
    end
    data.close
    puts ">>> End update of counties table..."
  end

  desc "Update zipcodes table"
  task :update_zipcodes => :update_counties do
    puts ">>> Begin update of zipcodes table..."
    url = "https://github.com/midwire/free_zipcode_data/raw/master/all_us_zipcodes.csv"
    data = open(url)
    file = nil
    if data.is_a? StringIO
      file = Tempfile.new('all_us_zipcodes.csv')
      file.write(data.read)
      file.flush
      file.close
    else
      file = data
    end
    FasterCSV.foreach(file.path, :headers => true) do |row|
      puts "Updating zipcode: [#{row['code']}], '#{row['city']}, #{row['state']}, #{row['county']}"
      # lookup state
      state = State.find_by_abbr!(row['state'])
      begin
        county = County.find_by_name_and_state_id!(row['county'], state.to_param)
      rescue Exception => e
        puts ">>> e: [#{e}]"
        puts ">>>> No county found for zipcode: [#{row['code']}], '#{row['city']}, #{row['state']}, #{row['county']}... SKIPPING..."
        next
      end
      zipcode = Zipcode.find_or_initialize_by_code(row['code'])
      zipcode.update_attributes!(
        :city => row['city'].titleize,
        :state_id => state.to_param,
        :county_id => county.to_param,
        :lat => row['lat'],
        :lon => row['lon']
      )
    end
    data.close
    puts ">>> End update of zipcodes table..."
  end

  desc "Populate or update the zipcodes related tables"
  task :update => :environment do
    Rake::Task['zipcodes:update_zipcodes'].invoke
  end

end
