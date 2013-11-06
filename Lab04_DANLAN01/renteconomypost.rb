#   Ruby Camping
#   Version 4
#   Daniel Lännström
#   danlan01
#

require 'economypost'
require 'config'
require 'date'

class RentEconomyPost < EconomyPost
    attr_reader :type

    @@type_names = TYPE_NAMES_HASH

    public
    def initialize(hash)
        if hash[:id] 
            load_from_db(hash[:id])
        else
            date = hash[:date]
            name = hash[:name]
            type = hash[:type]
            arrival = hash[:arrival]
            departure = hash[:departure]
            days = hash[:days]
            price = hash[:price]
            payment_plan = hash[:payment_plan]
            total = hash[:total]

            create_new(date, name, type, arrival, departure, days, price, payment_plan, total) 
        end
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

    private
    def get_last_id
        res = $db.query("SELECT id FROM EconomyPost ORDER BY id DESC;")
        row = res.fetch_row
        Integer(row == nil ? 0 : row[0])
    end

    def create_new(date, name, type, arrival, departure, days, price, payment_plan, total)
        id = get_last_id + 1

        $db.query("INSERT INTO EconomyPost VALUES (#{id}, \"rent\");")
        $db.query("INSERT INTO RentEconomyPost VALUES(#{id}, \"#{date}\", \"#{name}\", \"#{type.to_s}\", \"#{arrival}\", \"#{departure}\", #{days}, #{price}, \"#{payment_plan.to_s}\", #{total});")

        @id = id
        @date = date
        @name = name
        @type = type
        @arrival = arrival
        @departure = departure
        @days = days
        @price = price
        @payment_plan = payment_plan
        @total = total 
    end

    def load_from_db(id)
        res = $db.query("SELECT * FROM RentEconomyPost WHERE id=#{id};")
        row = res.fetch_row
        
        @id = Integer(row[0])
        @date = Date.parse(row[1])
        @name = row[2]
        @type = row[3].to_sym
        @arrival = row[4]
        @departure = row[5]
        @days = Integer(row[6])
        @price = Integer(row[7])
        @payment_plan = row[8] == '' ? nil : row[8].to_sym
        @total = Integer(row[9])
    end
end
