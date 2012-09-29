module Unicafe
  class Restaurant

    LIST_OF_RESTAURANTS = {
      10 => "Chemicum",
      11 => "Exactum"
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
