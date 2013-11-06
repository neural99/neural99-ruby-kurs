#   Ruby Camping
#   Version 4
#   Daniel Lännström
#   danlan01
#

require 'rentable'
require 'cabinguest'
require 'pricelist'
require 'economy'

class Cabin < Rentable
    attr_reader :name

    def initialize(name, economy, pricelist)
        load_from_db(name, economy, pricelist)

        super([:cabin])
    end

    def load_from_db(name, economy, pricelist)
        res = $db.query("SELECT * FROM Cabin WHERE name=\"#{name}\";")
        row = res.fetch_row

        @name = row[0]
        if row[1] == nil
            @guest = nil
        else
            @guest = CabinGuest.load_guest(Integer(row[1]), self)
            @guest.economy = economy
            @guest.pricelist = pricelist
        end
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
            weeks = (@guest.days / 7.0).ceil
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

    def check_in(type, pricelist, economy)
        guest = CabinGuest.new
        res = guest.check_in(self, :cabin, pricelist, economy)
        
        # nil aborts
        if res == nil
            return
        end                

        $db.query("UPDATE Cabin SET CustomerID=#{guest.customerId} WHERE name=\"#{@name}\";")

        @guest = guest
    end

    def check_out
        $db.query("UPDATE Cabin SET CustomerID=NULL WHERE name=\"#{@name}\";")
    end
end
