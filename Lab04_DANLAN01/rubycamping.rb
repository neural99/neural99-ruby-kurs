#   Ruby Camping
#   Version 4
#   Daniel Lännström
#   danlan01
#

require 'menu'
require 'menualternative'
require 'guest'
require 'cabin'
require 'plot'
require 'economy'
require 'pricelist'
require 'listmenu'
require 'economymenu'
require 'statisticsmenu'
require 'mainmenu'
require 'guestlist'
require 'config'
require 'mysql'

class RubyCamping
    # names from LOTR
    @@cabin_names = [ "Frodo",
                      "Samwise",
                      "Meriadoc",
                      "Peregrin",
                      "Gandalf",
                      "Aragon",
                      "Legolas",
                      "Gimli",
                      "Boromir",
                      "Sauron",
                      "Saruman",
                      "Gollum" ]

    public
    def initialize
        setup_db()

        @pricelist = PriceList.new
        @pricelist.load_from_db

        @economy = Economy.new
        @economy.load_from_db

        # List of plots, holds current guest information too
        @plots = Array.new(32)
        @plots.fill {|i| Plot.new(i+1, @economy, @pricelist)}

        # List of cabins
        @cabins = Array.new(12)
        @cabins.fill {|i| Cabin.new(@@cabin_names[i], @economy, @pricelist)}

        @rentables = @plots + @cabins

        # List of ALL guests 
        @guests = GuestList.new

        # Menus
        @lists_menu = ListMenu.new(@rentables, @guests)
        @economy_menu = EconomyMenu.new(@pricelist, @economy)
        @statistics_menu = StatisticsMenu.new(@guests, @economy)

        @main_menu = MainMenu.new(@rentables, @pricelist, @economy, @lists_menu, @economy_menu, @statistics_menu)
    end

    # Called from main
    def main_loop
        @main_menu.do_menu
        close_db
    end

    private
    def setup_db
        # No need to catch Mysql Error here because it provides a good error message
        # if we can't connect to db
        # Connection is global and open during the whole program execution
        $db = Mysql.new(DB_HOST, DB_USERNAME, DB_PASSWORD)
        $db.select_db(DB_NAME)
    end

    def close_db
        $db.close
    end
end
