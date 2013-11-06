#   Ruby Camping
#   Version 3
#   Daniel Lännström
#   danlan01
#

require 'pricelist'
require 'economy'

class Electricity 
    attr_accessor :before,
                  :after

    def initialize
        # At start up, set to a random value
        @before = 2000 + rand(2001)
        @after = nil
    end

    # Used electricity since last reset
    def energy_consumed
        @after-@before
    end

    # Called when a guest is checking out
    def reset
        @before = @after
        @after = nil
    end

    # similar to rentable, but you can't rent electricity
    def calc_price(guest, list, economy)
        price_per_kwatt = list.get_price(:electricity)
        kwatts = self.energy_consumed
        total = price_per_kwatt * kwatts
        # Add to bookeeping object
        economy.add(ElectricityEconomyPost.new({ :date =>   guest.departure,
                                                 :name =>   guest.name,
                                                 :kwatts => kwatts,
                                                 :price =>  price_per_kwatt,
                                                 :total =>  total }))
        return total
    end
end

