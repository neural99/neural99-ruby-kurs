#   Ruby Camping
#   Version 4
#   Daniel Lännström
#   danlan01
#

require 'input'
require 'plot'
require 'electricity'
require 'guest'
require 'date'

class PlotGuest < Guest
    attr_accessor :electricity,
                  :b_electricity

    # should we bill for electricity
    def wants_electricity?
        @b_electricity
    end

    def self.load_guest(id, rentable)
        g = PlotGuest.new
        g.load_from_db(id, rentable)
        g
    end

    def load_from_db(id, rentable)
        load_customer_from_db(id)

        # Only one stay at a given time with departure set to NULL
        res = $db.query("SELECT arrival,type,electricity FROM Stay WHERE customerID=#{id} AND departure IS NULL;")
        row = res.fetch_row

        @arrival = Date.parse(row[0])
        @departure = nil
        @type = row[1].to_sym
        @rentable = rentable
        @b_electricity = row[2] == "1" 
    end

    def check_in(rentable, type, pricelist, economy)
        while true # Until user has chosen 
            input = Input.read_string "Önskas el? (Ja/Nej): "
            
            # nil aborts
            if input == nil
                return nil
            end
        
            case input
            when /^(Ja)|(ja)$/
                @b_electricity = true
                break
            when /^(Nej)|(nej)$/
                @b_electricity = false
                break
            end 
            Input.print_error_and_wait "Svara ja eller nej. Försök igen. Tryck enter för att fortsätta"
        end

        super(rentable, type, pricelist, economy)
    end    

    # callback from Guest#check_in
    def do_check_in
       $db.query("INSERT INTO Stay VALUES(#{@customerId}, \"#{@arrival.to_s}\", NULL, \"#{@type.to_s}\", #{@rentable.number}, NULL, NULL, #{@b_electricity.to_s});")
    end

    # callback from Guest#check_out
    def do_check_out
        if self.wants_electricity? 
            # Random consumation
            energy_consumed = (10 + rand(71)) * self.days
            @electricity.after = @electricity.before + energy_consumed
        end
    end

    def check_out
        super

        # Reset gauge after everything else is done
        if @b_electricity 
            @electricity.reset(@rentable.number)
        end

        # A customer can only have one row in Stay with departure set to NULL
        $db.query("UPDATE Stay SET departure=\"#{@departure.to_s}\" WHERE customerID=#{@customerId} AND departure IS NULL;")
        @rentable.check_out
    end

    # Methods for printing with added gauge data 

    def check_out_print
        super
        if self.wants_electricity?
            puts "El: Ja"
            puts "#{@@names[7]} #{@electricity.before}"
            puts "#{@@names[8]} #{@electricity.energy_consumed}"
            puts "#{@@names[9]} #{@electricity.after}"
        else
            puts "El: Nej"
        end
    end

    def print_long
        super
        if self.wants_electricity?
            puts "  El: Ja"
            puts "  #{@@names[7]} #{@electricity.before}"
        else 
            puts "  El: Nej"
        end
    end

    def print_selection(index)
        super
        if self.wants_electricity?
            puts "  El: Ja"
            puts "  #{@@names[7]} #{@electricity.before}"
        else 
            puts "  El: Nej"
        end
    end
end
