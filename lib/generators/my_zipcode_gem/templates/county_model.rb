require 'memoist'

class County < ActiveRecord::Base
  extend Memoist
  belongs_to :state
  has_many :zipcodes

  validates :name, uniqueness: { scope: :state_id, case_sensitive: false },
                   presence: true

  scope :without_zipcodes, -> { joins("LEFT JOIN zipcodes ON zipcodes.county_id = counties.id").where("zipcodes.county_id IS NULL") }
  scope :without_state, -> { where("state_id IS NULL") }

  def cities
    zipcodes.map(&:city).sort.uniq
  end
  memoize :cities
end
