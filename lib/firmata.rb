require 'artoo'

connection :firmata, :adaptor => :firmata, :port => '127.0.0.1:8023'
device :led, :driver => :led, :pin => 13

work do
  every 1.second do
    led.toggle
  end
end
