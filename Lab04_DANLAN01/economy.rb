#   Ruby Camping
#   Version 4
#   Daniel Lännström
#   danlan01
#

require 'economypost'

class Economy
    include Enumerable

    def initialize(posts=[])
        @posts = posts
    end

    def load_from_db
        res = $db.query('SELECT id,type FROM EconomyPost;')
        while row = res.fetch_row
            add(EconomyPost.load_from_db(row[0], row[1].to_sym))
        end 
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

    def report_summary
        report $stdout
    end

    # Get the data from the posts and report
    def report(f)
        report = {}
        self.each do |x|
            hash = x.report
            hash.each do |k,v|
                report[k] ||= 0
                report[k] += v
            end
        end

        f.puts "El:"
        f.puts "kWh: #{report[:kwatts] ? report[:kwatts] : 0 }\tIntäkter: #{report[:electricity_revenue] ? report[:electricity_revenue] : 0 } SEK\n\n"

        [ [ "Stuger:",  :cabin_days, :cabin_revenue ],
          [ "Husvagnar:",  :caravan_days, :caravan_revenue ],
          [ "Husbilar:",  :camper_days, :camper_revenue ],
          [ "Tält:", :tent_days, :tent_revenue ],
          [ "Totalt:",  :total_days, :total_revenue] ].each do |k|
            f.puts "#{k[0]}"
            f.puts "Gästnätter: #{report[k[1]] ? report[k[1]] : 0}\tIntäkter: #{report[k[2]] ? report[k[2]] : 0} SEK\n\n"
        end
    end
    
    # Print all bookeeping posts sorted by date
    def print_all_posts(reverse=true)
        temp = Economy.new(reverse ? self.sort.reverse : self.sort) 
        temp.collect {|x| puts x.to_s + "\n" }
    end
end

