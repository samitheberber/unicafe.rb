# encoding: UTF-8

module Unicafe
  class Restaurant

    LIST_OF_RESTAURANTS = {
      1 => "Metsätalo",
      2 => "Olivia",
      3 => "Porthania",
      4 => "Päärakennus",
      5 => "Rotunda",
      6 => "Topelias",
      7 => "Valtiotiede",
      8 => "Ylioppilasaukio",
      10 => "Chemicum",
      11 => "Exactum",
      12 => "Physicum",
      13 => "Meilahti",
      14 => "Ruskeasuo",
      15 => "Soc & kom",
      16 => "Kookos",
      17 => "Valdemar",
      18 => "Biokeskus",
      19 => "Korona",
      21 => "Viikuna",
    }

    def self.find_by_name name
      self.find_by_id self.name_to_id(name)
    end

    def self.name_to_id name
      LIST_OF_RESTAURANTS.invert[name] || raise(NotFound)
    end

    class NotFound < Exception
    end

  end
end
