#   Ruby Camping
#   Version 3
#   Daniel Lännström
#   danlan01
#

require 'input'
require 'rentable'
require 'config'

# Class for representing a Guest in the booking system
class Guest  
    @@names = [ "Förnamn: ",  
                 "Efternamn: ",
                 "Adress: ",
                 "Telefon: ",
                 "Ankomstdatum: ",
                 "", 
                 "Typ: ",
                 "Elmätare innan besök: ",
                 "Elförbrukning: ",
                 "Elmätare efter besök: " ]

    attr_reader :firstName,
                :lastName,
                :adress,
                :departure,
                :arrival,
                :type

    # Used to check for duplicates
    def self.similar(g1, g2) 
        g1.firstName == g2.firstName &&
        g1.lastName == g2.lastName &&
        g1.adress == g2.adress
    end

    def name
        @firstName + " " + @lastName
    end

    def check_in(rentable, type, pricelist, economy)
        @firstName = Input.read_string("Förnamn: ")
        return nil if @firstName == nil
        @lastName = Input.read_string("Efternamn: ")
        return nil if @lastName == nil
        @adress = Input.read_multi_string("Address")
        return nil if @adress == nil
        @phone = Input.read_phone
        return nil if @phone == nil
        @arrival = Input.read_date("Ankomstdatum")
        return nil if @arrival == nil
        @rentable = rentable
        @type = type
        @departure = nil
        @pricelist = pricelist
        @economy = economy

        return true
    end

    def days
        (@departure - @arrival).to_i
    end

    def do_check_out
    end

    def check_out
        # Makes sure deparure is after arrival
        while true # Until we read valid departure date
            @departure = Input.read_date("Avresedatum")
            
            # Abort on nil
            if @departure == nil
                return
            end

            break if @departure >= @arrival
            Input.print_error_and_wait "Avresedatum är tidigare än ankomsdatum. Försök igen. Tryck enter för att fortsätta"
        end

        # Callback to subclass to do specific tasks
        self.do_check_out 

        # Print everything again...
        # with slightly more data
        self.check_out_print

        # Calc and print cost for stay
        cost = @rentable.calc_price(self, @pricelist, @economy)
        puts "Kostnad: #{cost} SEK"
    end

    def set_info(rentable, type, pricelist, economy, firstName, lastName, adress, phone, arrival)
        @firstName = firstName
        @lastName = lastName
        @adress = adress
        @phone = phone
        @arrival = arrival
        @rentable = rentable
        @departure = nil
        @pricelist = pricelist
        @economy = economy
        @type = type
    end

    # I want different formats of output during different mode of the program

    def check_out_print
        puts "#{@@names[0]} #{@firstName}"
        puts "#{@@names[1]} #{@lastName}"
        puts "#{@@names[2]} #{@adress}"
        puts "#{@@names[3]} #{@phone}"
        puts "#{@@names[4]} #{@arrival}"
        puts "#{@rentable.id}"
        puts "#{@@names[6]} #{TYPE_NAMES_HASH[@type]}"
    end

    def print_long
        puts "  #{@@names[0]} #{@firstName}"
        puts "  #{@@names[1]} #{@lastName}"
        puts "  #{@@names[2]} #{@adress}"
        puts "  #{@@names[3]} #{@phone}"
        puts "  #{@@names[4]} #{@arrival}"
        puts "  #{@@names[6]} #{TYPE_NAMES_HASH[@type]}"
    end

    def print_short
        puts "#{@firstName} #{@lastName}\n#{@adress}"
    end

    def print_selection(index)
        puts "Val #{index}:"
        puts "  #{@rentable.id}"
        puts "  #{@@names[6]} #{TYPE_NAMES_HASH[@type]}"
        puts "  #{@@names[0]} #{@firstName}"
        puts "  #{@@names[1]} #{@lastName}"
        puts "  #{@@names[2]} #{@adress}"
        puts "  #{@@names[3]} #{@phone}"
        puts "  #{@@names[4]} #{@arrival}"
    end
end
