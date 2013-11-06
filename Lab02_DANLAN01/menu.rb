#   Ruby Camping
#   Version 2
#   Daniel Lännström
#   danlan01
#

require 'input.rb'

# Plug and play menu class
class Menu
    # menu_object is a array of objects that implements do_selection
    def initialize(msg, prompt, menu_objects)
        @msg, @prompt, @menu_objects = msg, prompt, menu_objects
    end

    def do_menu
        # Continue until user enters valid selection
        while true
            puts @msg
            num = Input.read_number(@prompt)

            # nil is EOF
            if num == nil 
                puts
                return
            end

            begin
                @menu_objects[num-1].do_selection
                # Invalid selection
                rescue NoMethodError
                Input.print_error_and_wait "Ogiltigt menyval. Försök igen. Tryck enter för att fortsätta"
            end  
        end
    end
end
