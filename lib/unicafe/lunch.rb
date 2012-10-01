require 'feedzirra'
require 'net/http'

module Unicafe
  class Lunch

    attr_reader :name, :price, :date

    def initialize name, price, date
      @name = name
      @price = price
      @date = date
    end

    def self.lunches_for_restaurant id
      content = ::Net::HTTP.get(URI.parse("http://www.unicafe.fi/rss/fin/#{id}/"))
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
      self.new self.format_name(data), self.format_price(data), date
    rescue
    end

    def self.parse_date date
      require 'date'
      Date.parse date
    end

    def self.format_name data
      name_span = data.children.select{|elem| elem.name == 'span' && elem[:class] == "meal"}.first
      text_element = name_span.children.first
      text_element.to_s
    end

    def self.format_price data
      name_span = data.children.select{|elem| elem.name == 'span' && elem[:class] == "priceinfo"}.first
      text_element = name_span.children.first
      text_element.to_s
    end

  end
end
