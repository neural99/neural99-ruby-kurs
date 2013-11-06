#   Ruby Camping
#   Version 3
#   Daniel Lännström
#   danlan01
#

require 'input'
require 'plot'
require 'electricity'
require 'guest'

class PlotGuest < Guest
    attr_accessor :electricity,
                  :b_electricity

    # should we bill for electricity
    def wants_electricity?
        @b_electricity
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
        @electricity.reset
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
