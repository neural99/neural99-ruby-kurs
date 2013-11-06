#   Ruby Camping
#   Version 4
#   Daniel Lännström
#   danlan01
#

require 'input'
require 'menu'
require 'menualternative'
require 'pricelist'
require 'economy'

class EconomyMenu < Menu
    @@message = []
    @@message << "-------------------------------------------"
    @@message << "                   Ekonomi                 "
    @@message << "\n"
    @@message << "                    Meny                   "
    @@message << "               1. Visa prislista           "
    @@message << "               2. Redigera prislista       "
    @@message << "               3. Summera intäkter         "
    @@message << "               4. Visa bokföringsposter    "
    @@message << "\n"
    @@message << "               0. Återgå StartMeny         "
    @@message << "\n"
    @@message << "               Vad vill du göra?           "  
    @@message << "-------------------------------------------"
    @@message << "\n"
    
    public
    def initialize(pricelist, economy)
        @pricelist = pricelist
        @economy = economy

        show = MenuAlternative.new { show_pricelist }
        edit = MenuAlternative.new { edit_pricelist }
        report = MenuAlternative.new { report_revenue }
        bookkeeping = MenuAlternative.new { show_economy_posts }
        exit_action = MenuAlternative.new  { throw :done } 

        super(@@message, "> ", { 1 => show, 2 => edit, 3 => report, 4 => bookkeeping, 0 => exit_action })
    end

    private
    def show_pricelist
        puts @pricelist
    end

    def edit_pricelist
        show_pricelist

        while true
            num = Input.read_number("Välj post att redigera: ")
            
            # nil is EOF
            if num == nil
                puts
                return
            end

            if @pricelist[num] == nil
                Input.print_error_and_wait "Ogiltigt postnummer. Försök igen. Tryck enter för att fortsätta"
            else
                # Print selection to make sure user has selected the right one
                puts "Du valde:\n#{@pricelist[num]}"
                # Read new value
                value = Input.read_number("Nytt värde: ")
                @pricelist.edit(num, value)
                # Print new value 
                puts "Ny post:\n#{@pricelist[num]}"
                return
            end
        end 
    end

    def report_revenue
        @economy.report_summary
    end

    def show_economy_posts
        @economy.print_all_posts
    end

end
