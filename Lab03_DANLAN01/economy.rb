#   Ruby Camping
#   Version 3
#   Daniel Lännström
#   danlan01
#

require 'economypost'

class Economy
    include Enumerable

    def initialize(posts=[])
        @posts = posts
    end

    def each
       @posts.each { |x| yield x }
    end

    # Adds a EconomyPost to the list
    def add(entry)
        @posts << entry
    end

    def delete(entry)
        @posts.delete entry
    end
    
    def length
        @posts.length
    end

    # Get the data from the posts and report
    def report_summary
        report = {}
        self.each do |x|
            hash = x.report
            hash.each do |k,v|
                report[k] ||= 0
                report[k] += v
            end
        end

        puts "El:"
        puts "kWh: #{report[:kwatts] ? report[:kwatts] : 0 }\tIntäkter: #{report[:electricity_revenue] ? report[:electricity_revenue] : 0 } SEK\n\n"

        [ [ "Stuger:",  :cabin_days, :cabin_revenue ],
          [ "Husvagnar:",  :caravan_days, :caravan_revenue ],
          [ "Husbilar:",  :camper_days, :camper_revenue ],
          [ "Tält:", :tent_days, :tent_revenue ],
          [ "Totalt:",  :total_days, :total_revenue] ].each do |k|
            puts "#{k[0]}"
            puts "Gästnätter: #{report[k[1]] ? report[k[1]] : 0}\tIntäkter: #{report[k[2]] ? report[k[2]] : 0} SEK\n\n"
        end
    end
    
    # Print all bookeeping posts sorted by date
    def print_all_posts(reverse=true)
        temp = Economy.new(reverse ? self.sort.reverse : self.sort) 
        temp.collect {|x| puts x.to_s + "\n" }
    end
end

