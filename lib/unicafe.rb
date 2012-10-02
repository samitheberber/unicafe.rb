require "unicafe/version"
require "unicafe/price_parser"
require "unicafe/lunch"
require "unicafe/restaurant"
require "geocoder"

module Unicafe

  def self.get_restaurant name
    ::Unicafe::Restaurant.find_by_name name
  end

end
