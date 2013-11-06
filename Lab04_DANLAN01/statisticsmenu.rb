#   Ruby Camping
#   Version 4
#   Daniel Lännström
#   danlan01
#

require 'date'
require 'input'
require 'menu'
require 'menualternative'

class StatisticsMenu < Menu
    @@message = []
    @@message << "-------------------------------------------"
    @@message << "                   Statisik                "
    @@message << "\n"
    @@message << "                    Meny                   "
    @@message << "               1. Campingstatistik         "
    @@message << "               2. Adresslista              "
    @@message << "\n"
    @@message << "               0. Återgå StartMeny         "
    @@message << "\n"
    @@message << "               Vad vill du göra?           "  
    @@message << "-------------------------------------------"
    @@message << "\n"
    
    public
    def initialize(guests, economy)
        @guests = guests
        @economy = economy

        stat = MenuAlternative.new { save_stat }
        guestlist = MenuAlternative.new { save_guestlist }
        exit_action = MenuAlternative.new  { throw :done } 

        super(@@message, "> ", { 1 => stat, 2 => guestlist, 0 => exit_action })
    end

    private
    
    def gen_path(name)
        # Generate file name from current time
        # Unsure if NTFS supports ':' in file names. Replaced it with 
        # space to be sure it works on windows
        now = DateTime::now()
        path = "#{now.year}-"
        path += "0" if now.month < 10 
        path += "#{now.month}-"
        path += "0" if now.day < 10
        path += "#{now.day} "
        path += "0" if now.hour < 10
        path += "#{now.hour} "
        path += "0" if now.min < 10
        path += "#{now.min} - #{name}"

        # Add number to the end if it already exists
        if File.exist?(path + ".txt")
            i = 2 
            while File.exist?(path + "#{i}.txt")
                i += 1
            end

            path = path + "#{i}" 
        end

        # Adds extension for windows friendiness 
        path += ".txt"

        path
    end

    def save_stat
        path = gen_path("Statistik")
        File.open(path, "w") { |f| @economy.report f }
        puts "Uppgifter sparade till fil: #{path}"
    end

    def save_guestlist
        path = gen_path("Addresslista")
        File.open(path, "w") { |f| @guests.each { |g| g.print_short_file(f) } }
        puts "Uppgifter sparade till fil: #{path}"
    end
end
