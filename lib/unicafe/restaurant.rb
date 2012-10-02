# encoding: UTF-8

module Unicafe
  class Restaurant

    LIST_OF_RESTAURANTS = {
      1 => {name: "Metsätalo", latitude: 60.172577, longitude: 24.948878},
      2 => {name: "Olivia", latitude: 60.175077, longitude: 24.952979},
      3 => {name: "Porthania", latitude: 60.169878, longitude: 24.948669},
      4 => {name: "Päärakennus", latitude: 60.169178, longitude: 24.949297},
      5 => {name: "Rotunda", latitude: 60.170332, longitude: 24.950791},
      6 => {name: "Topelias", latitude: 60.171806, longitude: 24.95067},
      7 => {name: "Valtiotiede", latitude: 60.173897, longitude: 24.953095},
      8 => {name: "Ylioppilasaukio", latitude: 60.169092, longitude: 24.93992},
      10 => {name: "Chemicum", latitude: 60.205108, longitude: 24.963357},
      11 => {name: "Exactum", latitude: 60.20509, longitude: 24.961209},
      12 => {name: "Physicum", latitude: 60.204755, longitude: 24.963200},
      13 => {name: "Meilahti", latitude: 60.190212, longitude: 24.908911},
      14 => {name: "Ruskeasuo", latitude: 60.206341, longitude: 24.895871},
      15 => {name: "Soc & kom", latitude: 60.173054, longitude: 24.95049},
      16 => {name: "Kookos", latitude: 60.181034, longitude: 24.958652},
      18 => {name: "Biokeskus", latitude: 60.226922, longitude: 25.013707},
      19 => {name: "Korona", latitude: 60.226922, longitude: 25.013707},
      21 => {name: "Viikuna", latitude: 60.23049, longitude: 25.020544}
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

    def distance(latitude, longitude)
      Geocoder::Calculations.distance_between([self.latitude, self.longitude],
                                              [latitude, longitude],
                                              :units => :km)
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

    def self.nearest(latitude, longitude)
      distances_with_restaurants = self.distances(latitude, longitude)
      distances_with_restaurants[distances_with_restaurants.keys.min]
    end

    def self.distances(latitude, longitude)
      distances = {}
      LIST_OF_RESTAURANTS.each do |key, hash|
        restaurant = self.find_by_id(key)
        distances[restaurant.distance(latitude, longitude)] = restaurant
      end
      distances
    end

    class NotFound < Exception
    end
  end
end
