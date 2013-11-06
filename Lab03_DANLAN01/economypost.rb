#   Ruby Camping
#   Version 3
#   Daniel Lännström
#   danlan01
#

class EconomyPost
    attr_accessor :date,
                  :name,
                  :total
    def <=>(another)
        self.date <=> another.date
    end

    def report
        Hash.new
    end
end
