#   Ruby Camping
#   Version 4
#   Daniel Lännström
#   danlan01
#

class EconomyPost
    attr_accessor :id,
                  :date,
                  :name,
                  :total

    def self.load_from_db(id, type)
        case type
            when :rent then RentEconomyPost.new({:id => id})
            when :electricity then ElectricityEconomyPost.new({:id => id})
        end
    end

    def <=>(another)
        self.date <=> another.date
    end

    def report
        Hash.new
    end
end
