module Unicafe
  class Restaurant

    def self.find_by_name name
      self.find_by_id self.name_to_id(name)
    end

    class NotFound < Exception
    end

  end
end
