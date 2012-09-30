module Unicafe
  class Lunch

    def self.lunches_for_restaurant id
      content = Net::HTTP.get(URI.parse("http://www.unicafe.fi/rss/fin/#{id}/"))
      self.parse_data content
    end

  end
end
