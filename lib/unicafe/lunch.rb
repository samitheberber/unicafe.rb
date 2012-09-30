require 'feedzirra'
module Unicafe
  class Lunch

    def self.lunches_for_restaurant id
      content = Net::HTTP.get(URI.parse("http://www.unicafe.fi/rss/fin/#{id}/"))
      self.parse_data content
    end

    def self.parse_data data
      parsed_data = Feedzirra::Feed.parse data
      self.format_data parsed_data
    end

  end
end
