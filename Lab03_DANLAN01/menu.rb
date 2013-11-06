#   Ruby Camping
#   Version 3
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
        b_exit = false
        while not b_exit
            puts @msg
            num = Input.read_number(@prompt)

            # nil is EOF
            if num == nil 
                puts
                return
            end

            menu_obj = @menu_objects[num]

            # Invalid selection
            if menu_obj == nil
                Input.print_error_and_wait "Ogiltigt menyval. Försök igen. Tryck enter för att fortsätta"
            else
                menu_obj.do_selection b_exit
            end
        end
    end
end
