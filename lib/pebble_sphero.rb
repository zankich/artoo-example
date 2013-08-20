require 'artoo'
 
connection :pebble, :adaptor => :pebble, :port => '127.0.0.1:4567', :id => "378B"
device :watch, :driver => :pebble, :connection => :pebble
 
connection :sphero, :adaptor => :sphero, :port => '127.0.0.1:4568'
device :sphero, :driver => :sphero, :connection => :sphero
 
work do
  on watch, :media_control => :button_push
 
  stopped
end
 
def button_push(*data)
  return if data[1].nil?
 
  case data[1].button
  when :previous
    move(270)
 
  when :next
    move(90)
 
  when :playpause
    if @rolling
      sphero.stop
      stopped
    else
      move(0)
    end
    
  else
    puts "WAT"
  end
end
 
def move(heading)
  sphero.roll 90, heading
  @rolling = true
  watch.set_nowplaying_metadata("Left", "Right", "Stop")
end
 
def stopped
  @rolling = false
  watch.set_nowplaying_metadata("Left", "Right", "Roll")
end
