#   Ruby Camping
#   Version 3
#   Daniel Lännström
#   danlan01
#

require 'economypost'
require 'config'

class RentEconomyPost < EconomyPost
    attr_reader :type

    @@type_names = TYPE_NAMES_HASH

    def initialize(hash)
        @date = hash[:date]
        @name = hash[:name]
        @type = hash[:type]
        @arrival = hash[:arrival]
        @departure = hash[:departure]
        @days = hash[:days]
        @price = hash[:price]
        @payment_plan = hash[:payment_plan]
        @total = hash[:total]

    end

    def to_s
        str = "#{@date}:\nNamn: #{@name}\nTyp: #{@@type_names[@type]}\nFrån #{@arrival} till #{@departure} (#{@days} dagar)\n#{@price} SEK per #{@payment_plan == :weekly ? 'vecka' : 'dag'}\nTOTALT: #{@total} SEK\n" 
    end

    def report
        hash = Hash.new
        hash[:total_days] = @days
        hash[(@type.to_s+"_days").to_sym] = @days
        hash[:total_revenue] = @total
        hash[(@type.to_s+"_revenue").to_sym] = @total

        hash
    end
end
