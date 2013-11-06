#   Ruby Camping
#   Version 4
#   Daniel Lännström
#   danlan01
#

require 'economypost'
require 'date'

class ElectricityEconomyPost < EconomyPost
    public
    def initialize(hash)
        if hash[:id]
            load_from_db(hash[:id])
        else 
            date   = hash[:date]
            name   = hash[:name]
            kwatts = hash[:kwatts]
            price  = hash[:price]
            total  = hash[:total] 

            create_new(date, name, kwatts, price, total)
        end
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

    private
    def load_from_db(id)
        res = $db.query("SELECT * FROM ElectricityEconomyPost WHERE id=#{id};")
        row = res.fetch_row
        
        @id = Integer(row[0])
        @date = Date.parse(row[1])
        @name = row[2]
        @kwatts = Integer(row[3])
        @price = Integer(row[4])
        @total = Integer(row[5])
    end

    def create_new(date, name, kwatts, price, total)
        id = get_last_id + 1

        $db.query("INSERT INTO EconomyPost VALUES (#{id}, \"electricity\");")
        $db.query("INSERT INTO ElectricityEconomyPost VALUES (#{id}, \"#{date}\", \"#{name}\", #{kwatts}, #{price}, #{total});")

        @id = id
        @date = date
        @name = name
        @kwatts = kwatts
        @price = price
        @total = total
    end

    def get_last_id
        res = $db.query("SELECT id FROM EconomyPost ORDER BY id DESC;")
        row = res.fetch_row
        Integer(row == nil ? 0 : row[0])
    end

end
