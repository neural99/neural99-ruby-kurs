#   Ruby Camping
#   Version 4
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

    def initialize(number, economy, pricelist)
        load_from_db(number, economy, pricelist)

        super([:caravan, :camper, :tent])
    end

    def load_from_db(number, economy, pricelist)
        res = $db.query("SELECT * FROM Plot WHERE id=#{number};")
        row = res.fetch_row

        @number = Integer(row[0])
        @electricity = Electricity.new(Integer(row[2]))
        if row[1] == nil
            @guest = nil
        else
            @guest = PlotGuest.load_guest(Integer(row[1]), self)
            @guest.electricity = @electricity 
            @guest.economy = economy
            @guest.pricelist = pricelist 
        end

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

    def check_in(type, pricelist, economy)
        guest = PlotGuest.new
        res = guest.check_in(self, type, pricelist, economy)

        # nil aborts
        if res == nil
            return
        end                

        $db.query("UPDATE Plot SET customerID=#{guest.customerId} WHERE id=#{@number};")

        @guest = guest
        @guest.electricity = @electricity
    end

    def check_out
        $db.query("UPDATE Plot SET customerID=NULL WHERE id=#{@number};");
    end
end
