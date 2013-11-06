#   Ruby Camping
#   Version 4
#   Daniel Lännström
#   danlan01
#

require 'pricelist'
require 'economy'

class Electricity 
    attr_accessor :before,
                  :after

    def initialize(b)
        @before = b
        @after = nil
    end

    # Used electricity since last reset
    def energy_consumed
        @after-@before
    end

    # Called when a guest is checking out
    def reset(plotID)
        $db.query("UPDATE Plot SET gauge=#{@after} WHERE id=#{plotID};")

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

