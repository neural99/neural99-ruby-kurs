#   Ruby Camping
#   Version 3
#   Daniel Lännström
#   danlan01
#

require 'economypost'

class ElectricityEconomyPost < EconomyPost
    def initialize(hash)
        @date   = hash[:date]
        @name   = hash[:name]
        @kwatts = hash[:kwatts]
        @price  = hash[:price]
        @total  = hash[:total] 
    end

    def to_s
        "#{@date}:\nNamn: #{@name}\n#{@kwatts} kWh för #{@price} per kWh\nTOTALT: #{@total}\n"
    end

    def report
        hash = Hash.new
        hash[:kwatts] = @kwatts
        hash[:electricity_revenue] = @total
        hash[:total_revenue] = @total
        
        hash
    end
end
