#   Ruby Camping
#   Version 4
#   Daniel Lännström
#   danlan01
#

require 'guest'

class GuestList
    include Enumerable

    def each
        res = $db.query("SELECT * FROM Customers ORDER BY id ASC;")
        while row = res.fetch_row
            # create a temp guest object
            g = Guest.new
            g.set_info(Integer(row[0]), row[1], row[2], row[3], row[4])
            yield g
        end 
    end
end
