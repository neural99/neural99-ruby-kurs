#   Ruby Camping
#   Version 1
#   Daniel Lännström
#   danlan01
#

# We need Date in date.rb
require 'date.rb'

class Guest
  def initialize(firstName, lastName, adress, phone, arrival, plot, gauge) 
    @names = [ "Förnamn: ",  
               "Efternamn: ",
               "Adress: ",
               "Telefon: ",
               "Ankomstdatum: ",
               "Tomt nr: ", 
               "Elmätare: " ]

    @data = [ firstName,
              lastName,
              adress,
              phone,
              arrival,
              plot,
              gauge ]
  end

  def print
    (0 .. @names.length).each do | i |
      name = @names[i]
      value = @data[i]
      puts "#{name} #{value}"
    end
  end
end

def read_date
  while true
    print "Ankomstdatum (YYYY-MM-DD): "
    date = gets.chomp

    # Super simple check
    if date =~ /\d{4}\-\d{2}-\d{2}/
      # Use Date's parse method to validate date
      begin 
        return Date.parse(date) 
      rescue ArgumentError
        print_error_and_wait "Ogiltigt datum. Försök igen. Tryck enter för att fortsätta"
      end
    else  
      print_error_and_wait "Ogiltigt datum. Försök igen. Tryck enter för att fortsätta"
    end
  end
end

def read_phone
  while true
    print "Telefon: "
    phone = gets.chomp

    # Checks for area code but nothing fancier
    if phone =~ /\d+\-\d+/ 
      return phone
    else
      print_error_and_wait "Ange riktnummer och telefonnummer. Försök ingen. Tryck enter för att fortsätta"
    end
  end
end

def read_string(prompt)
  print prompt
  return gets.chomp
end

def read_multi_string(prompt)
  puts "Mata in " + prompt + ". Avsluta med '.' på en egen rad"
  str = []

  while true 
    tmp = gets.chomp
    if tmp == '.'
      break
    else
      str << tmp
    end
  end

  return str.join("\n")
end

def checking_in
  firstName = read_string("Förnamn: ")
  lastName = read_string("Efternamn: ")
  adress = read_multi_string("Address")
  phone = read_phone
  arrival = read_date
  plot = 1 + rand(32)
  gauge = 2000 + rand(2001)
  
  $guest = Guest.new(firstName, lastName, adress, phone, arrival, plot, gauge)
end

def checking_out
  if $guest == nil
    print_error_and_wait "Ingen gäst incheckad. Försök igen. Tryck enter för att fortsätta"
  else
    $guest.print
    puts "Tryck enter för att avsluta"
    gets
    exit
  end
end

#error helper function
def print_error_and_wait(str)
  puts str
  gets
end

def main_menu
  menu = []
  menu << "-------------------------------------------"
  menu << "        Välkommen till Ruby Camping!       "
  menu << "\n"
  menu << "                    Meny                   "
  menu << "               1. Incheckning              "
  menu << "               2. Utcheckning              "
  menu << "               3. Avsluta                  "
  menu << "\n"
  menu << "               Vad vill du göra?           "  
  menu << "-------------------------------------------"
  menu << "\n"

  while true 
    puts menu.join("\n")
    print '> '
    selection = gets.chomp

    # makes sure it's a number
    if selection =~ /\d+/ 
      if selection == "1"
        checking_in 
      elsif selection == "2"
        checking_out
      elsif selection == "3" 
        exit 
      else 
        print_error_and_wait "Ogiltigt menyval. Försök igen. Tryck enter för att fortsätta"
      end
    else
      print_error_and_wait "Ej en siffra. Försök igen. Tryck enter för att fortsätta"
    end
  end
end

main_menu
