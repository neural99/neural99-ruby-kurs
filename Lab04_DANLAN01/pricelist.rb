#   Ruby Camping
#   Version 4
#   Daniel Lännström
#   danlan01
#

require 'pricelistentry'

class PriceList
    include Enumerable

    @@header = "Nr  Beskrivning\tKostnad"

    def initialize(posts=[])
        @posts = posts 
    end
    
    def load_from_db
        res = $db.query("SELECT id FROM PriceListEntry;")
        while row = res.fetch_row
            add(PriceListEntry.new(row[0]))
        end
    end

    def add(entry)
        @posts << entry
    end

    def each
       @posts.each { |x| yield x }
    end

    def length
        @posts.length
    end
    
    def to_s
        @@header + "\n" + self.collect {|x| x.to_s }.join("\n")
    end

    def get_price(symbol)
        @posts.find {|x| x.match_symbol(symbol)}.value
    end

    def [](i)
        @posts[i]
    end

    def edit(index, new_value)
        @posts[index].value = new_value
    end
end

