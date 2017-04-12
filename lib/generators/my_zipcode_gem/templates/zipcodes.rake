require 'open-uri'
require 'csv'

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
    CSV.foreach(file.path, :headers => true) do |row|
      puts "Updating state: [#{row['name']}]"
      state = State.where(abbr: row['abbr']).first_or_initialize
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
    CSV.foreach(file.path, :headers => true) do |row|
      puts "Updating county: [#{row['name']}]"
      # lookup state
      state = State.find_by_abbr!(row['state'])
      county = County.where(name: row['name'], state_id: state.to_param).first_or_initialize
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
    CSV.foreach(file.path, :headers => true) do |row|
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
      zipcode = Zipcode.where(code: row['code']).first_or_initialize
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

  desc "Export US States to a .csv file"
  task :export_states => :environment do
    @states = State.order("name ASC")
    csv_string = CSV.generate do |csv|
      csv << ["abbr", "name"]
      @states.each do |state|
        csv << [
          state.abbr,
          state.name
          ]
      end
    end
    filename = "all_us_states.csv"
    open("#{Rails.root}/db/#{filename}", 'w') do |f|
      f.write(csv_string)
    end
  end

  desc "Export all US Counties to a .csv file"
  task :export_counties => :environment do
    @counties = County.order("name ASC")
    csv_string = CSV.generate do |csv|
      csv << ["name", "state", "county_seat"]
      @counties.each do |county|
        csv << [
          county.name,
          county.state.abbr,
          county.county_seat
          ]
      end
    end
    filename = "all_us_counties.csv"
    open("#{Rails.root}/db/#{filename}", 'w') do |f|
      f.write(csv_string)
    end
  end

  desc "Export the zipcodes with county and state data"
  task :export_zipcodes => :environment do
    @zipcodes = Zipcode.order("code ASC")
    csv_string = CSV.generate do |csv|
      csv << ["code", "city", "state", "county", "area_code", "lat", "lon"]
      @zipcodes.each do |zip|
        csv << [
          zip.code,
          zip.city,
          zip.state.abbr,
          zip.county.nil? ? '' : zip.county.name,
          zip.area_code,
          zip.lat,
          zip.lon
          ]
      end
    end
    filename = "all_us_zipcodes.csv"
    open("#{Rails.root}/db/#{filename}", 'w') do |f|
      f.write(csv_string)
    end
  end

  desc "Export zipcodes, states and counties tables"
  task :export => :environment do
    Rake::Task['zipcodes:export_states'].invoke
    Rake::Task['zipcodes:export_counties'].invoke
    Rake::Task['zipcodes:export_zipcodes'].invoke
  end

end
