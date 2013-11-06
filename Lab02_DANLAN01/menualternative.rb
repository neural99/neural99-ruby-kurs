#   Ruby Camping
#   Version 2
#   Daniel Lännström
#   danlan01
#

# Represents a menu alternative, uses blocks to store action
class MenuAlternative
    def initialize(&action)
        @action = action
    end
    def do_selection
        @action.call(self)
    end
end
