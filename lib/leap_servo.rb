require 'artoo'
 
connection :digispark, :adaptor => :littlewire, :vendor => 0x1781, :product => 0x0c9f
device :servo1, :connection => :digispark, :driver => :servo, :pin => 0
device :servo2, :connection => :digispark, :driver => :servo, :pin => 1
 
connection :leapmotion, :adaptor => :leapmotion, :port => '127.0.0.1:6437'
device :leapmotion, :connection => :leapmotion, :driver => :leapmotion
 
work do
  on leapmotion, :hand => :wave
 
  every(0.1) do
    puts "#{x},#{y}"
    servo2.move(x)
    servo1.move(y)
  end
end
 
def x
  @x ||= 90
end
 
def y
  @y ||= 90
end
 
def wave(sender, hand)
  return unless hand
  @x = hand.palm_x.from_scale(-300..300).to_scale(45..135)
  @y = hand.palm_y.from_scale(-200..200).to_scale(45..135)
end
