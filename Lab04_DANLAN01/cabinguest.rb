#   Ruby Camping
#   Version 4
#   Daniel Lännström
#   danlan01
#
require 'input'
require 'cabin'
require 'guest'

class CabinGuest < Guest
    attr_reader :payment_plan

    @@check_in_message = []
    @@check_in_message << "Välj prisplan:"
    @@check_in_message << "0: Per dag"
    @@check_in_message << "1: Per vecka"

    def self.load_guest(id, rentable)
        g = CabinGuest.new
        g.load_from_db(id, rentable)
        g
    end

    def load_from_db(id, rentable)
        load_customer_from_db(id)

        res = $db.query("SELECT arrival,type,payment_plan FROM Stay WHERE customerID=#{id} AND departure IS NULL;")
        row = res.fetch_row

        @arrival = Date.parse(row[0])
        @departure = nil 
        @type = row[1].to_sym
        @rentable = rentable
        @payment_plan = row[2].to_sym
    end
    
    def check_in(rentable, type, pricelist, economy)
        # user must select daily or weely payment plan 
        puts @@check_in_message.join("\n")
        while true
            selection = Input.read_number("Nr: ")

            # nil aborts
            if selection == nil
                return nil
            end

            case selection
            when 0
                @payment_plan = :daily
                break
            when 1
                @payment_plan = :weekly
                break
            end
            Input.print_error_and_wait "Ogilltigt val. Gilltiga val är 0, 1. Försök igen. Tryck enter för att fortsätta"
        end

        # continue in superclass
        super(rentable, type, pricelist, economy)
    end

    def do_check_in
       $db.query("INSERT INTO Stay VALUES(#{@customerId}, \"#{@arrival.to_s}\", NULL, \"#{@type.to_s}\", NULL, \"#{@rentable.name}\", \"#{@payment_plan.to_s}\", NULL);")
    end

    def check_out
        super

        # departure is NULL for current guests
        $db.query("UPDATE Stay SET departure=\"#{@departure.to_s}\" WHERE customerID=#{@customerId} AND departure IS NULL;")
        @rentable.check_out
    end
end
