class Zipcode < ActiveRecord::Base
  
  belongs_to :county
  belongs_to :state
  
  validates :code, :uniqueness => true, :presence => true
  validates :state_id, :county_id, :city, :presence => true
  
  scope :without_county, -> { where("county_id IS NULL") }
  scope :without_state, -> { where("state_id IS NULL") }
  scope :ungeocoded, -> { where("lat IS NULL OR lon IS NULL") }

  class << self
    def find_by_city(city)
      includes(:county).where("city like '#{city}%'")
    end
  end

  def county_and_zip
    "#{county.name}: #{code}"
  end

  def latlon
    [lat, lon]
  end

  def is_geocoded?
    (!lat.nil? && !lon.nil?)
  end
end
