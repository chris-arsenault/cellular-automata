require 'gosu'
require './automata'
require 'RMagick'
include Magick

def bitwise(p, place)
  bit = 2 ** place
  p & bit == bit
end

def build_image
  locality = 2
  length = 2*locality + 1
  iterations = (2 ** length)
  (2**iterations).times do |p|
    pattern = iterations.times.map { |i| bitwise(p,i)}
    puts "Doing pattern #{p} with pattern #{pattern.join(', ')}"
      @automata = Automata.new(1000, pattern, locality)
      @automata.loop(500)

      generated_image = Image.new(@automata.width, @automata.height) { self.background_color = 'black' }
      @automata.grid.height.times do |row|
        @automata.grid.width.times do |column|
          if @automata.grid[row,column] == '1'
            generated_image.pixel_color(column, row, 'red')
          end
        end
      end
      generated_image.write("output/#{p}.jpg")
  end
end

build_image

# class Display < Gosu::Window
#   def initialize(width=1000, height=1000, fullscreen=false)
#     super
#     self.caption = 'Cellular Automata'
#     @automata = Automata.new
#     @last_update = Time.now
#     @generated_image = Image.new(1000, 1000) { self.background_color = 'black' }
#     @once = false
#   end
#
#   def update
#     # if Time.now - @last_update > 1
#       @automata.loop_once
#       @automata.grid.height.times do |row|
#         next if @automata.grid.drawn(row)
#         @automata.grid.width.times do |column|
#           if @automata.grid[row,column] == '1'
#             @generated_image.pixel_color(column, row, 'red')
#           end
#         end
#         @automata.grid.set_drawn(row)
#       end
#       @generated_image.write('./hi.jpg')
#       @once = true
#       @last_update = Time.now
#     # end
#   end
#
#   def color
#     Gosu::Color.argb(0xff_ff0000)
#   end
#
#   def draw
#     if @once
#       Gosu::Image.load_tiles('./hi.jpg', 1000, 1000)[0].draw(0, 0, 0)
#     end
#   end
# end
#
#
# Display.new.show
