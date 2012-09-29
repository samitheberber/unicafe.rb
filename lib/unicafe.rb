require "unicafe/version"
require "unicafe/restaurant"

module Unicafe

  def self.get_restaurant name
    ::Unicafe::Restaurant.find_by_name name
  end

end
