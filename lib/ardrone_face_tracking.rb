require 'artoo'

connection :capture, :adaptor => :opencv_capture, :source => "tcp://192.168.1.1:5555"
device :capture, :driver => :opencv_capture, :connection => :capture, :interval => 0.0033

connection :video, :adaptor => :opencv_window, :title => "Video"
device :video, :driver => :opencv_window, :connection => :video, :interval => 0.0033

connection :ardrone, :adaptor => :ardrone, :port => '192.168.1.1:5556'
device :drone, :driver => :ardrone, :connection => :ardrone

HAAR = "#{Dir.pwd}/lib/haarcascade_frontalface_alt.xml"


work do
  on capture, :frame => :on_image
  drone.start
  drone.take_off
  after(8.second) { drone.up(0.5) }
  after(10.seconds) { drone.hover }
  after(13.seconds) {
    every(0.5) {
      @detect_on = true
      opencv = capture.opencv
      video.image = opencv.image
      detect(opencv)
    }
    after(30.seconds){ drone.land }
  }
end

def on_image(*value)
  if !detect_on
    video.image = value[1].image
  end
end

def detect_on
  @detect_on = (@detect_on.nil? ? false : true)
end

def detect(opencv)
  begin
    drone.hover
    biggest = 0
    face = nil
    opencv.detect_faces(HAAR).each do |f|
      if f.width > biggest
        biggest = f.width
        face = f
      end
    end
    if !face.nil? && (face.class != OpenCV::CvSeq) && (face.width <= 100 && face.width >= 45)
      opencv.draw_rectangles!([face])
      center_x = opencv.image.width * 0.5
      turn = -( face.center.x - center_x ) / center_x
      puts "turning: #{turn}"
      if turn < 0 
        drone.turn_right(turn.abs)
      else 
        drone.turn_left(turn.abs)
      end
      video.image = opencv.image
    end
  rescue Exception => e
    drone.hover
    puts e.message
  end
end
