require 'artoo'

connection :sphero, :adaptor => :sphero, :port => '127.0.0.1:4569'
device :sphero, :driver => :sphero
  
work do
  sphero.stop
end
