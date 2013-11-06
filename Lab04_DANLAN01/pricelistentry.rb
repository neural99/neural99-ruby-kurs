#   Ruby Camping
#   Version 4
#   Daniel Lännström
#   danlan01
#

class PriceListEntry
    attr_reader   :post_number,
                  :description,
                  :value,
                  :symbol

    # update db when the value is changed
    def value=(newvalue)
        @value = newvalue
        
        $db.query("UPDATE PriceListEntry SET value=#{newvalue} WHERE id=#{@post_number};")
    end

    def initialize(post_number)
        res = $db.query("SELECT * FROM PriceListEntry WHERE id = #{post_number}")
        row = res.fetch_row
        @post_number = Integer(row[0])
        @description = row[1]
        @value = Integer(row[2])
        @symbol = row[3].to_sym
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
