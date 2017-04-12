require 'memoist'

class State < ActiveRecord::Base
  extend Memoist
  has_many :zipcodes
  has_many :counties

  validates :abbr, uniqueness: { case_sensitive: false }, presence: true
  validates :name, uniqueness: { case_sensitive: false }, presence: true

  def cities
    zipcodes.map(&:city).sort.uniq
  end
  memoize :cities
end
