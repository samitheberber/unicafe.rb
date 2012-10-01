# encoding: UTF-8

module Unicafe
  class PriceParser

    MAUKKAASTI = '4.20'
    EDULLISESTI = '2.60'

    def parse price_string
      case price_string
      when 'Maukkaasti'
        MAUKKAASTI
      when 'Edullisesti'
        EDULLISESTI
      when /^Makeasti (.*)$/
        price_string.match(/([,0-9]+)/)[0].gsub(',','.')
      else
        raise PriceError
      end
    end

    class PriceError < Exception
    end

  end
end
