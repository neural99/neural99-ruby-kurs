#   Ruby Camping
#   Version 3
#   Daniel Lännström
#   danlan01
#

require 'menu'
require 'menualternative'
require 'guest'
require 'rentable'
require 'config'

class MainMenu < Menu
    @@message = []
    @@message << "-------------------------------------------"
    @@message << "        Välkommen till Ruby Camping!       "
    @@message << "\n"
    @@message << "                    Meny                   "
    @@message << "               1. Incheckning              "
    @@message << "               2. Utcheckning              "
    @@message << "               3. Listor                   "
    @@message << "               4. Ekonomi                  "
    @@message << "               5. Avsluta                  "
    @@message << "\n"
    @@message << "               Vad vill du göra?           "  
    @@message << "-------------------------------------------"
    @@message << "\n"

    @@checking_in_message = []
    @@checking_in_message << "Välj type:"
    @@checking_in_message << "0: Stuga"
    @@checking_in_message << "1: Husvagn"
    @@checking_in_message << "2: Husbil"
    @@checking_in_message << "3: Tält"

    public
    def initialize(rentables, guests, pricelist, economy, list_menu, economy_menu)
        checking_in = MenuAlternative.new do
            checking_in(guests, rentables, pricelist, economy)
        end

        checking_out = MenuAlternative.new do
            checking_out(rentables)
        end

        lists = MenuAlternative.new do
            sub_menu list_menu
        end

        economy_action = MenuAlternative.new do
            sub_menu economy_menu
        end

        exit_action = MenuAlternative.new { exit }

        super(@@message, "> ",    { 1 => checking_in,
                                    2 => checking_out,
                                    3 => lists,
                                    4 => economy_action,
                                    5 => exit_action })
    end

    private
    # helper method
    def check_in(guests, rentables, type, pricelist, economy)
        rentable = Rentable.assign(rentables, type)

        if rentable == nil 
            # TODO: Make this specific to which rentable we want
            puts "VARNING FULLBOKAT!!"
        else
            rentable.check_in(guests, rentables, type, pricelist, economy)
        end
    end
    
    def checking_in(guests, rentables, pricelist, economy)
        puts @@checking_in_message.join("\n")

        type = nil

        while true
            selection = Input.read_number("Nr: ")
            
            # nil aborts
            if selection == nil
                return
            end            

            if TYPES_ORDERED[selection] != nil
                type = TYPES_ORDERED[selection]
                break
            else
                Input.print_error_and_wait "Ogiltigt val. Försök igen. Tryck enter för att fortsätta"
            end
        end

        check_in(guests, rentables, type, pricelist, economy)
    end

    def checking_out(rentables)
        tmp = rentables.select { |p| p.guest != nil }
        tmp.each_with_index { |p,i| p.guest.print_selection i }

        # Make sure we have guests...
        if tmp.length == 0
            puts "INGA AKTUELLA GÄSTER!!"
        else
            # until a valid plot number has been read
            while true 
                selection = Input.read_number("Nr: ")

                # nil is eof
                if selection == nil
                    puts
                    break
                end

                p = tmp[selection]
                if p != nil 
                    p.guest.check_out

                    # Empty plot
                    p.guest = nil
                    break   
                end
                Input.print_error_and_wait "Ogiltigt val. Försök igen. Tryck enter för att fortsätta"
            end
        end
    end

    def sub_menu(menu)
        catch(:done) do
            menu.do_menu 
        end
    end
end
