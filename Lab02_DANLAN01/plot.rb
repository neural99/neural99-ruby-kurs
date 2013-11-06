#   Ruby Camping
#   Version 2
#   Daniel Lännström
#   danlan01
#

require 'electricity.rb'

class Plot 
    def initialize(number)
        @number = number
        @gauge = Electricity.new
        @guest = nil
    end

    def to_s
        "#{@number}"
    end

    attr_accessor :guest 

    attr_reader :gauge,
                :number
end
