#   Ruby Camping
#   Version 3
#   Daniel Lännström
#   danlan01
#

require 'rentable'
require 'cabinguest'
require 'pricelist'
require 'economy'

class Cabin < Rentable
    def initialize(name)
        @name = name
        @guest = nil

        super([:cabin])
    end

    def id
        "Stuga: #{@name}"
    end

    # price depends on guest's priceplan
    def calc_price(guest, pricelist, economy)
        price_per_day = nil
        price_per_week = nil

        if @guest.payment_plan == :daily
            price_per_day = pricelist.get_price(:cabin_day) 
            rent = price_per_day * @guest.days
        else
            price_per_week = pricelist.get_price(:cabin_week) 
            # round up of course
            weeks = (@guest.days / 7).ceil
            rent = price_per_week * weeks
        end

        # Add to bookkeeping object
        economy.add(RentEconomyPost.new({ :date =>        @guest.departure,
                                          :name =>        @guest.name,
                                          :type =>        @guest.type,
                                          :arrival =>     @guest.arrival,
                                          :departure =>   @guest.departure,
                                          :days =>        @guest.days,
                                          :payment_plan => price_per_day ? :daily : :weekly,
                                          :price =>       price_per_day ? price_per_day : price_per_week,
                                          :total =>       rent}))

        return rent
    end

    def check_in(guests, rentables, type, pricelist, economy)
        guest = CabinGuest.new
        res = guest.check_in(self, :cabin, pricelist.copy, economy)
        
        # nil aborts
        if res == nil
            return
        end                

        @guest = guest
        guests.add(@guest)  
    end
end
