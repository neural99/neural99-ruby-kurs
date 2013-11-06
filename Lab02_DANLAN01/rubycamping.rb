#   Ruby Camping
#   Version 2
#   Daniel Lännström
#   danlan01
#

require 'menu.rb'
require 'menualternative.rb'
require 'guest.rb'

class RubyCamping
    @@message = []
    @@message << "-------------------------------------------"
    @@message << "        Välkommen till Ruby Camping!       "
    @@message << "\n"
    @@message << "                    Meny                   "
    @@message << "               1. Incheckning              "
    @@message << "               2. Utcheckning              "
    @@message << "               3. Lista aktuella gäster    "
    @@message << "               4. Lista samtliga gäster    "
    @@message << "               5. Avsluta                  "
    @@message << "\n"
    @@message << "               Vad vill du göra?           "  
    @@message << "-------------------------------------------"
    @@message << "\n"

    public
    def initialize
        # List of plots, holds current guest information too
        @plots = (1..32).to_a
        @plots = @plots.collect { | i | Plot.new(i) } 

        # List of ALL guests 
        @guests = []

        add_first_guests

        @checking_in = MenuAlternative.new do
            plot = assign_plot

            # Make sure there is empty plots
            if plot == nil 
                puts "VARNING ALLA PLATSER UPPTAGNA!!"
            else 
                guest = Guest.new
                guest.check_in(plot, @plots[plot-1].gauge.gauge)

                @plots[plot-1].guest = guest

                add_guest(guest)
            end
        end

        @checking_out = MenuAlternative.new do
            puts "Checking out"
            tmp = @plots.select { | p | p.guest != nil }
            tmp.each { | p | p.guest.print_selection }

            # Make sure we have guests...
            if tmp.length == 0
                puts "INGA AKTUELLA GÄSTER!!"
            else
                # until a valid plot number has been read
                while true 
                    selection = Input.read_number("Tomt nr: ")

                    # nil is eof
                    if selection == nil
                        puts
                        break
                    end

                    p = @plots[selection-1]
                    if p != nil && p.guest != nil
                        p.guest.check_out

                        # Increase gauge at plot 
                        p.gauge.increase(p.guest.energy_consumed)

                        # Empty plot
                        p.guest = nil
                        break   
                    end
                    Input.print_error_and_wait "Ogiltigt platsnummer. Försök igen. Tryck enter för att fortsätta"
                end
            end
        end

        @list_all = MenuAlternative.new do
            @guests.each { | g | g.print_short }
        end

        @list_current = MenuAlternative.new do
            @plots.each do | p | 
                puts "Plats: #{p.number}"
                if p.guest == nil
                    puts "LEDIG"
                else
                    p.guest.print_long
                end
            end
        end

        @exit_action = MenuAlternative.new do
            exit
        end
    end

    # Called from main
    def main_loop
        Menu.new(@@message, "> ", [ @checking_in, @checking_out, @list_current, @list_all, @exit_action ]).do_menu
    end

    private
    def add_first_guests
        5.times do | i | 
            plot = assign_plot
            tmp = Guest.new
            tmp.set_info(plot, @plots[plot-1].gauge.gauge, "Test", "Person#{i}", "Lingonskogen\n666 66 AAAA", "08-123", Date.parse("2010-01-01"))
            @plots[plot-1].guest = tmp
            add_guest(tmp)
        end
    end

    # Assign a random empty plot
    def assign_plot
        empty = @plots.select { | g | g.guest == nil }
        return nil if empty.length == 0
        i = rand(empty.length)
        empty[i].number
    end

    def add_guest(guest)
        # Deletes duplicates
        @guests.reject! { | g | Guest.similar(g, guest) }
        @guests.insert(0, guest)
    end
end
