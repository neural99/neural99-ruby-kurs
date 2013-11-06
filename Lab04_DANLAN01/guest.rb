#   Ruby Camping
#   Version 4
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
                 "Elmätare efter besök: ",
                 "Kundnummer: " ]

    attr_reader :customerId,
                :firstName,
                :lastName,
                :adress,
                :departure,
                :arrival,
                :type
    attr_writer :economy,
                :pricelist

    def name
        @firstName + " " + @lastName
    end

    # make sure the customerId is not present in Stay table
    def already_present(id)
        res = $db.query("SELECT * FROM Stay WHERE customerID=#{id} AND departure IS NULL;")
        row = res.fetch_row
        p row
        row != nil
    end

    def check_in(rentable, type, pricelist, economy)
        while true
            @customerId = Input.read_number("Kundnummer (0 för ny kund): ")
            return nil if @customerId == nil

            if @customerId == 0 
                @firstName = Input.read_string("Förnamn: ")
                return nil if @firstName == nil
                @lastName = Input.read_string("Efternamn: ")
                return nil if @lastName == nil
                @adress = Input.read_multi_string("Address")
                return nil if @adress == nil
                @phone = Input.read_phone
                return nil if @phone == nil
                break
            else
                # make sure customer is not currently checked in
                if already_present(@customerId)
                    Input.print_error_and_wait "Gäst redan incheckad. Försök igen. Tryck enter för att fortsätta." 
                elsif load_customer_from_db(@customerId)
                    break
                # failure to load customer from db
                else
                    Input.print_error_and_wait "Ogilltigt kundnummer. Försök igen. Tryck enter för att fortsätta." 
                end
            end
        end

        @arrival = Input.read_date("Ankomstdatum")
        return nil if @arrival == nil
        @rentable = rentable
        @type = type
        @departure = nil
        @pricelist = pricelist
        @economy = economy

        if @customerId == 0
            insert_new_customer(@firstName, @lastName, @adress, @phone)
        end

        # callback
        self.do_check_in

        return true
    end

    def load_customer_from_db(id)
        res = $db.query("SELECT * FROM Customers WHERE id=#{id};")
        row = res.fetch_row
        if row 
            @customerId = Integer(row[0])
            @firstName = row[1]
            @lastName = row[2]
            @adress = row[3]
            @phone = row[4]
            return true
        else
            return false
        end  
    end

    def get_last_id
        res = $db.query("SELECT id FROM Customers ORDER BY id DESC;")
        row = res.fetch_row
        Integer(row == nil ? 0 : row[0])
    end

    def insert_new_customer(firstName, lastName, adress, phone)
        @customerId = get_last_id + 1
        $db.query("INSERT INTO Customers VALUES (#{@customerId}, \"#{firstName}\", \"#{lastName}\", \"#{adress}\", \"#{phone}\");")
    end

    def days
        (@departure - @arrival).to_i
    end

    def do_check_out
    end

    def do_check_in
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

    def set_info(customerId, firstName, lastName, adress, phone)
        @customerId = customerId
        @firstName = firstName
        @lastName = lastName
        @adress = adress
        @phone = phone
    end

    # I want different formats of output during different mode of the program

    def check_out_print
        puts "#{@@names[10]} #{@customerId}"
        puts "#{@@names[0]} #{@firstName}"
        puts "#{@@names[1]} #{@lastName}"
        puts "#{@@names[2]} #{@adress}"
        puts "#{@@names[3]} #{@phone}"
        puts "#{@@names[4]} #{@arrival}"
        puts "#{@rentable.id}"
        puts "#{@@names[6]} #{TYPE_NAMES_HASH[@type]}"
    end

    def print_long
        puts "  #{@@names[10]} #{@customerId}"
        puts "  #{@@names[0]} #{@firstName}"
        puts "  #{@@names[1]} #{@lastName}"
        puts "  #{@@names[2]} #{@adress}"
        puts "  #{@@names[3]} #{@phone}"
        puts "  #{@@names[4]} #{@arrival}"
        puts "  #{@@names[6]} #{TYPE_NAMES_HASH[@type]}"
    end

    def print_short
        print_short_file($stdout)
    end

    def print_short_file(f)
        f.puts "#{@customerId} #{@firstName} #{@lastName}\n#{@adress}"
    end

    def print_selection(index)
        puts "Val #{index}:"
        puts "  #{@rentable.id}"
        puts "  #{@@names[6]} #{TYPE_NAMES_HASH[@type]}"
        puts "  #{@@names[10]} #{@customerId}"
        puts "  #{@@names[0]} #{@firstName}"
        puts "  #{@@names[1]} #{@lastName}"
        puts "  #{@@names[2]} #{@adress}"
        puts "  #{@@names[3]} #{@phone}"
        puts "  #{@@names[4]} #{@arrival}"
    end

end
