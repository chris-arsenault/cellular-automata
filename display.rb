require 'RMagick'
include Magick

require './automata'
require './log'

LOCALITY = 1
POOL_SIZE = 6
THREADING_METHOD = :thread
WIDTH = 200
HEIGHT = 100
Log.debug_mode = true

def bitwise(p, place)
  bit = 2 ** place
  p & bit == bit
end

def single_iteration(iterations, locality, pattern_index)
  pattern = iterations.times.map {|i| bitwise(pattern_index, i)}
  Log.debug "Doing pattern #{pattern_index} with pattern #{pattern.join(', ')}"
  @automata = Automata.new(WIDTH, pattern, locality)
  @automata.loop(HEIGHT)

  generated_image = Image.new(@automata.width, @automata.height) {self.background_color = 'black'}
  @automata.grid.height.times do |row|
    @automata.grid.width.times do |column|
      if @automata.grid[row, column] == '1'
        generated_image.pixel_color(column, row, 'red')
      end
    end
  end
  generated_image.write("output/#{pattern_index}.jpg")
end

def build_image
  `mkdir output`
  `rm output/*`
  iterations = (2 ** (2*LOCALITY + 1))

  run_job = Proc.new do |jobs|
    begin
      jobs.each do |pattern|
        single_iteration(iterations, LOCALITY, pattern)
      end
    rescue ThreadError => e
      Log.debug e.message
    end
  end

  case THREADING_METHOD
    when :none
      run_job.call
    when :thread
      workers = []
      (2**iterations).times.each_slice(POOL_SIZE).to_a.each do |slice|
        workers.push(Thread.new do
          run_job.call(slice)
        end)
      end
      workers.map(&:join)
    when :fork
      (2**iterations).times.each_slice(POOL_SIZE).to_a.each do |slice|
        fork do
          run_job.call(slice)
        end
      end
      Process.waitall
    else
      Log.debug 'dont be a derp!!'
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
