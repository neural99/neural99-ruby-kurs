#   Ruby Camping
#   Version 4
#   Daniel Lännström
#   danlan01
#

require 'menu'
require 'menualternative'
require 'rentable'
require 'plot'

class ListMenu < Menu
    @@message = []
    @@message << "-------------------------------------------"
    @@message << "                   Listor                  "
    @@message << "\n"
    @@message << "                    Meny                   "
    @@message << "               1. Lista aktuella gäster    "
    @@message << "               2. Lista samtliga gäster    "
    @@message << "\n"
    @@message << "               0. Återgå StartMeny         "
    @@message << "\n"
    @@message << "               Vad vill du göra?           "  
    @@message << "-------------------------------------------"
    @@message << "\n"

    public
    def initialize(rentables, guests)
        @rentables = rentables
        @guests = guests

        list_all = MenuAlternative.new { list_all_guests }
        list_current = MenuAlternative.new { list_current_guests }
        pexit = MenuAlternative.new { throw :done }
    
        super(@@message, '> ', { 1 => list_current, 2 => list_all, 0 => pexit })
    end

    private
    def list_all_guests
        @guests.each { |g| g.print_short }
    end

    def list_current_guests
        @rentables.each do | p | 
            puts "#{p.id}"
            if p.guest == nil
                puts "LEDIG" 
            else
                p.guest.print_long
            end
        end
    end
end

