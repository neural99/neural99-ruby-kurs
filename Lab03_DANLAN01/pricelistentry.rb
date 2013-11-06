#   Ruby Camping
#   Version 3
#   Daniel Lännström
#   danlan01
#

class PriceListEntry
    attr_reader   :post_number,
                  :description,
                  :value
    attr_writer   :value

    def initialize(post_number, description, value, symbol) 
        @post_number, @description, @value, @symbol = post_number, description, value, symbol
    end

    def <=>(another)
        self.post_number <=> another.post_number
    end

    def match_symbol(s)
        @symbol == s
    end

    def to_s
        "#{@post_number}:  #{@description}\t#{@value}"
    end
end
