#   Ruby Camping
#   Version 4
#   Daniel Lännström
#   danlan01
#

# Change to add rentables
TYPE_NAMES_HASH = { :cabin   => "Stuga",
                    :caravan => "Husvagn",
                    :camper  => "Husbil", 
                    :tent    => "Tält" }
TYPES_ORDERED = [ :cabin, :caravan, :camper, :tent ]

# Database connection information
DB_HOST = 'localhost'
DB_USERNAME = 'root'
DB_PASSWORD = ''
DB_NAME = 'rubycamping'
