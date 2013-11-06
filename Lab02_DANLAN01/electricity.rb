#   Ruby Camping
#   Version 2
#   Daniel Lännström
#   danlan01
#

class Electricity
    def initialize
     # At start up, set to a random value
        @gauge = 2000 + rand(2001)
    end
    def to_s
        "#{@gauge}"
    end
  # Increase when a guest is checking out
    def increase(amount) 
        @gauge += amount
    end

    attr_reader :gauge
end

