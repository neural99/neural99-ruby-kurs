#   Ruby Camping
#   Version 3
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
require 'mainmenu'
require 'guestlist'

class RubyCamping
    # names from LORD
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
        # Adds initial prices to pricelist
        @pricelist = PriceList.new
        @pricelist.add(PriceListEntry.new(0, "Elpris per kWh", 5, :electricity))
        @pricelist.add(PriceListEntry.new(1, "Stuga per dag", 450, :cabin_day))
        @pricelist.add(PriceListEntry.new(2, "Husvagn per dag", 200, :caravan))
        @pricelist.add(PriceListEntry.new(3, "Husbil per dag", 300, :camper))
        @pricelist.add(PriceListEntry.new(4, "Tält per dag", 150, :tent))
        @pricelist.add(PriceListEntry.new(5, "Stuga per vecka", 3000, :cabin_week))

        @economy = Economy.new

        # List of plots, holds current guest information too
        @plots = Array.new(32)
        @plots.fill {|i| Plot.new(i+1)}

        # List of cabins
        @cabins = Array.new(12)
        @cabins.fill {|i| Cabin.new(@@cabin_names[i])}

        @rentables = @plots + @cabins

        # List of ALL guests 
        @guests = GuestList.new

        # Menus
        @lists_menu = ListMenu.new(@rentables, @guests)
        @economy_menu = EconomyMenu.new(@pricelist, @economy)

        @main_menu = MainMenu.new(@rentables, @guests, @pricelist, @economy, @lists_menu, @economy_menu)
    end

    # Called from main
    def main_loop
        @main_menu.do_menu
    end
end
