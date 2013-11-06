#   Ruby Camping
#   Version 4
#   Daniel Lännström
#   danlan01
#

# Represents a menu alternative, uses blocks to store action
class MenuAlternative
    def initialize(&action)
        @action = action
    end
    def do_selection(b_exit)
        @action.call(self, b_exit)
    end
end
