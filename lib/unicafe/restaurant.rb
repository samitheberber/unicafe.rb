# encoding: UTF-8

module Unicafe
  class Restaurant

    LIST_OF_RESTAURANTS = {
      1 => {name: "Metsätalo"},
      2 => {name: "Olivia"},
      3 => {name: "Porthania"},
      4 => {name: "Päärakennus"},
      5 => {name: "Rotunda"},
      6 => {name: "Topelias"},
      7 => {name: "Valtiotiede"},
      8 => {name: "Ylioppilasaukio"},
      10 => {name: "Chemicum", latitude: 60.205108, longitude:24.963357},
      11 => {name: "Exactum"},
      12 => {name: "Physicum"},
      13 => {name: "Meilahti"},
      14 => {name: "Ruskeasuo"},
      15 => {name: "Soc & kom"},
      16 => {name: "Kookos"},
      17 => {name: "Valdemar"},
      18 => {name: "Biokeskus"},
      19 => {name: "Korona"},
      21 => {name: "Viikuna"}
    }

    def initialize id
      @id = id
    end

    def name
      @name ||= LIST_OF_RESTAURANTS[@id][:name]
    end

    def latitude
      @latitude ||= LIST_OF_RESTAURANTS[@id][:latitude]
    end

    def longitude
      @longitude ||= LIST_OF_RESTAURANTS[@id][:longitude]
    end

    def lunches
      ::Unicafe::Lunch.lunches_for_restaurant(@id)
    end

    def self.find_by_id id
      self.new id
    end

    def self.find_by_name name
      self.find_by_id self.name_to_id(name)
    end

    def self.name_to_id name
      LIST_OF_RESTAURANTS.select{|key, hash| hash[:name] == name}.map{|key, hash| key}.first || raise(NotFound)
    end

    class NotFound < Exception
    end

  end
end
