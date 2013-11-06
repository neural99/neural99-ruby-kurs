#   Ruby Camping
#   Version 3
#   Daniel Lännström
#   danlan01
#

require 'electricity'
require 'rentable'
require 'electricityeconomypost'
require 'renteconomypost'
require 'plotguest'

class Plot < Rentable
    attr_reader :electricity,
                :number

    def initialize(number)
        @number = number
        @electricity = Electricity.new
        @guest = nil

        super([:caravan, :camper, :tent])
    end

    def id
        "Tomt nr: #{@number}"
    end

    # guest is assumed to be a plot guest
    def calc_price(guest, list, economy)
        price_per_day = list.get_price(@guest.type)
        days = @guest.days
        rent = price_per_day * days 

        economy.add(RentEconomyPost.new({ :date =>      @guest.departure,
                                          :name =>      @guest.name,
                                          :type =>      @guest.type,
                                          :arrival =>   @guest.arrival,
                                          :departure => @guest.departure,
                                          :days =>      days,
                                          :price =>     price_per_day,
                                          :total =>     rent}))

        electricity_price = @guest.wants_electricity? ? @electricity.calc_price(guest, list, economy) : 0

        return rent + electricity_price
    end

    def check_in(guests, rentables, type, pricelist, economy)
        guest = PlotGuest.new
        res = guest.check_in(self, type, pricelist.copy, economy)

        # nil aborts
        if res == nil
            return
        end                

        @guest = guest
        @guest.electricity = @electricity
        guests.add(@guest)
    end
end
