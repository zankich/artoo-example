require 'artoo'

connection :capture, :adaptor => :opencv_capture, :source => "tcp://192.168.1.1:5555"
device :capture, :driver => :opencv_capture, :connection => :capture, :interval => 0.0033

connection :video, :adaptor => :opencv_window, :title => "Video"
device :video, :driver => :opencv_window, :connection => :video, :interval => 0.0033

connection :ardrone, :adaptor => :ardrone, :port => '192.168.1.1:5556'
device :drone, :driver => :ardrone, :connection => :ardrone

work do
  on capture, :frame => proc { |*value|
    begin
      video.image = value[1].image
    rescue Exception => e
      puts e.message
    end
  }

  drone.start
  drone.take_off
  
  after(15.seconds) { drone.hover.land }
  after(20.seconds) { drone.stop }
end
