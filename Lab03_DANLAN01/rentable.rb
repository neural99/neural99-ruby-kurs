#   Ruby Camping
#   Version 3
#   Daniel Lännström
#   danlan01
#

# base class for Cabin, Plot
class Rentable
    attr_accessor :guest

    # List of types that can occupy this rentable
    def initialize(types)
        @types = types
    end

    def calc_price(guest, pricelist, economy)
        0 # free 
    end

    def id
        ""
    end

    # can type guests stay in this rentable?
    def can_occupy?(type)
        (@guest == nil) && (@types.index(type) != nil)
    end

    # selects a random rentable where type guests can stay 
    def self.assign(rentables, type)
        empty = rentables.select {|g| g.can_occupy?(type)}
        return nil if empty.length == 0
        empty.choice
    end
end
