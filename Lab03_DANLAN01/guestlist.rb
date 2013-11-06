#   Ruby Camping
#   Version 3
#   Daniel Lännström
#   danlan01
#

require 'guest'

class GuestList
    include Enumerable

    def each
        @guests.each {|g| yield g}
    end

    def add(guest)
        # Deletes duplicates
        @guests.reject! { | g | Guest.similar(g, guest) }
        @guests.insert(0, guest)
    end

    def initialize
        @guests = []
    end

    def [](index)
        @guests[index]
    end
end
