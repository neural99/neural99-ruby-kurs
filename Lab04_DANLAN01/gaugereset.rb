require 'config'
require 'mysql'

$database_connection = Mysql.new(DB_HOST, DB_USERNAME, DB_PASSWORD)
$database_connection.select_db(DB_NAME)

(1..32).each do |x|
    before = 2000 + rand(2001)
    res = $database_connection.query("insert into Plot values(#{x},NULL,#{before});")
end

$database_connection.close
