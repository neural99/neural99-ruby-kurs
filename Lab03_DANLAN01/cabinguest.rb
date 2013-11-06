#   Version 3
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
end
