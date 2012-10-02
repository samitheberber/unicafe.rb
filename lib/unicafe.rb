require "unicafe/version"
require "unicafe/price_parser"
require "unicafe/lunch"
require "unicafe/restaurant"
require "geocoder"

module Unicafe

  def self.get_restaurant name
    ::Unicafe::Restaurant.find_by_name name
  end

  def self.nearest(latitude, longitude)
    ::Unicafe::Restaurant.nearest(latitude, longitude)
  end

  def self.distances(latitude, longitude)
    ::Unicafe::Restaurant.distances(latitude, longitude)
  end
end
