class Zipcode < ActiveRecord::Base
  attr_accessible :code, :city, :state_id, :county_id, :lat, :lon
  
  belongs_to :county
  belongs_to :state
  
  validates :code, :uniqueness => true, :presence => true
  validates :state_id, :county_id, :city, :presence => true
  
  scope :without_county, where("county_id IS NULL")
  scope :without_state, where("state_id IS NULL")
  scope :ungeocoded, where("lat IS NULL OR lon IS NULL")

  class << self
    def find_by_city_state(city, state)
      find(:first, :conditions => "city like '#{city}%' AND states.abbr like '%#{state}%'", :include => [:county => :state])
    end
  end

  def latlon
    [lat, lon]
  end

  def is_geocoded?
    (!lat.nil? && !lon.nil?)
  end
end
