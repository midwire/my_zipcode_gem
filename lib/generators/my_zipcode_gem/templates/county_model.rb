require 'memoist'

class County < ActiveRecord::Base
  extend Memoist
  belongs_to :state
  has_many :zipcodes

  validates :name, uniqueness: { scope: :state_id, case_sensitive: false },
                   presence: true

  scope :without_zipcodes, lambda {
    county = County.arel_table
    zipcodes = Zipcode.arel_table
    zipjoin = county
        .join(zipcodes, Arel::Nodes::OuterJoin)
        .on(zipcodes[:county_id].eq(county[:id]))
    joins(zipjoin.join_sources).where(zipcodes[:county_id].eq(nil))
  }
  scope :without_state, lambda {
    where(state_id: nil)
  }

  def cities
    zipcodes.map(&:city).sort.uniq
  end
  memoize :cities
end
