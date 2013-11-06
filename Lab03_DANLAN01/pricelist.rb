#   Ruby Camping
#   Version 3
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

    def each
       @posts.each { |x| yield x }
    end

    # Adds a PriceListEntry to the list
    def add(entry)
        @posts << entry
    end

    def delete(entry)
        @posts.delete entry
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

    # Makes a deep copy
    def copy
        Marshal.load(Marshal.dump(self))
    end
end

