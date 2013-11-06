#   Ruby Camping
#   Version 2
#   Daniel Lännström
#   danlan01
#

require 'input.rb'
require 'plot.rb'
require 'electricity.rb'

# Class for representing a Guest in the booking system
class Guest
    @@names = [ "Förnamn: ",  
                 "Efternamn: ",
                 "Adress: ",
                 "Telefon: ",
                 "Ankomstdatum: ",
                 "Tomt nr: ", 
                 "Elmätare innan besök: ",
                 "Elförbrukning: ",
                 "Elmätare efter besök: " ]

    attr_reader :energy_consumed,
                :firstName,
                :lastName,
                :adress

    # Used to check for duplicates
    def self.similar(g1, g2) 
        g1.firstName == g2.firstName &&
        g1.lastName == g2.lastName &&
        g1.adress == g2.adress
    end

    def check_in(plot, gauge)
        @firstName = Input.read_string("Förnamn: ")
        @lastName = Input.read_string("Efternamn: ")
        @adress = Input.read_multi_string("Address")
        @phone = Input.read_phone
        @arrival = Input.read_date("Ankomstdatum")
        @plot = plot
        @gauge = gauge
        @departure = nil
        @energy_consumed = nil
    end

    def check_out
        # Makes sure deparure is after arrival
        while true # Until we read valid departure date
            @departure = Input.read_date("Avresedatum")
            break if @departure >= @arrival
            Input.print_error_and_wait "Avresedatum är tidigare än ankomsdatum. Försök igen. Tryck enter för att fortsätta"
        end
    
        # Random consumation
        @energy_consumed = (10 + rand(71)) * (@departure - @arrival).to_i

        # Print everything again...
        # with slightly more data
        puts "#{@@names[0]} #{@firstName}"
        puts "#{@@names[1]} #{@lastName}"
        puts "#{@@names[2]} #{@adress}"
        puts "#{@@names[3]} #{@phone}"
        puts "#{@@names[4]} #{@arrival}"
        puts "#{@@names[5]} #{@plot}"
        puts "#{@@names[6]} #{@gauge}"
        puts "#{@@names[7]} #{@energy_consumed}"
        total = @gauge + @energy_consumed
        puts "#{@@names[8]} #{total}"
            
    end

    def set_info(plot, gauge, firstName, lastName, adress, phone, arrival)
        @firstName = firstName
        @lastName = lastName
        @adress = adress
        @phone = phone
        @arrival = arrival
        @plot = plot
        @gauge = gauge
        @departure = nil
        @energy_consumed = nil
    end

    # I want different formats of output during different mode of the program

    def print_long
        puts "  #{@@names[0]} #{@firstName}"
        puts "  #{@@names[1]} #{@lastName}"
        puts "  #{@@names[2]} #{@adress}"
        puts "  #{@@names[3]} #{@phone}"
        puts "  #{@@names[4]} #{@arrival}"
        puts "  #{@@names[6]} #{@gauge}"
    end

    def print_short
        puts "#{@firstName} #{@lastName}\n#{@adress}"
    end

    def print_selection
        puts "#{@@names[5]} #{@plot}"
        puts "  #{@@names[0]} #{@firstName}"
        puts "  #{@@names[1]} #{@lastName}"
        puts "  #{@@names[2]} #{@adress}"
        puts "  #{@@names[3]} #{@phone}"
        puts "  #{@@names[4]} #{@arrival}"
        puts "  #{@@names[6]} #{@gauge}"
    end
end
