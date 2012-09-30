require 'feedzirra'
module Unicafe
  class Lunch

    def self.lunches_for_restaurant id
      content = Feedzirra::Feed.fetch_and_parse("http://www.unicafe.fi/rss/fin/#{id}/")
      self.format_data content
    end

  end
end
