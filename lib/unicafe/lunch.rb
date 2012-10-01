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

    def self.format_data data
      data.entries.map{|date| self.format_lunches_of_date(date)}.flatten.compact
    end

    def self.format_lunches_of_date data
      date = self.parse_date data.title
      Nokogiri::HTML::DocumentFragment.parse(data.summary).children.map{ |lunch|
        self.format_lunch date, lunch
      }
    end

    def self.format_lunch date, data
      self.new self.format_name(data), self.format_description(data), date
    end

    def self.parse_date date
      require 'date'
      Date.parse date
    end

  end
end
