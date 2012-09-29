require "unicafe/version"
require "unicafe/restaurant"

module Unicafe

  def self.get_restaurant name
    ::Unicafe::Restaurant.new name
  end

end
