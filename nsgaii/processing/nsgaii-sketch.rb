require_relative "../ruby/nsgaii-oo.rb"

attr_reader :algorithm
attr_reader :num_bits
attr_reader :pixel_multiplier

PIXEL = 40
CANVAS = 800
SEARCH_SPACE_MIN = -10
SEARCH_SPACE_MAX = 10
VEL_SPACE_MIN = -100
VEL_SPACE_MAX = 100

FRAME_RATE = 40
POP_SIZE = 150
MAX_GENS = POP_SIZE - 1
NUM_BITS = 400

def settings
  size(CANVAS, CANVAS)
end

def setup
  sketch_title 'NSGAII'
  frame_rate FRAME_RATE
  background(255)

  # problem configuration
  problem_size = 1
  search_space = Array.new(problem_size) {|i| [SEARCH_SPACE_MIN, SEARCH_SPACE_MAX]}

  # execute the algorithm
  @algorithm = NSGAII.new(_search_space: search_space, _max_gens: MAX_GENS, _pop_size: POP_SIZE, _p_cross: 0.98, _bits_per_param: NUM_BITS)
  @location = Vec2D.new
end

def draw
  background(255)
  @location.x = 0
  @location.y = 0

  @algorithm.search(frame_count)

  if @algorithm.bitstring
    puts "draw[#{frame_count}]: #{@algorithm.bitstring}"
    @algorithm.bitstring.each_char do |bit|
      if bit.to_i == 0
        draw_pixel(location: @location, r:255, g:255, b:255)
      else
        draw_pixel(location: @location)
      end

      if @location.x < width
        @location.x += PIXEL
      else
        @location.x = 0
        @location.y += PIXEL
      end
    end
  end

  if @recording
    save_frame("#{File.expand_path(File.dirname(__FILE__))}/output/capture-######.png")
  end

  noLoop if MAX_GENS > 0 && frame_count == MAX_GENS
  # noLoop if @step

  @recording = false
end

def draw_pixel(location: location, size: PIXEL, r:0, g:0, b:0)
  # puts "location x:#{location.x} y:#{location.y}"
  no_stroke
  fill(r, g, b)
  rect(location.x, location.y, size, size)
end

# NOT When running pry
# def key_pressed
#   puts key
#   # return unless key == 'S' || key == 's'
#   # @recording = true
#   if key == 'R' || key == 'r'
#     @pause = !@pause
#     @pause ? noLoop : loop
#   end
#
#   if key == 'S' || key == 's'
#     @step = true
#   end
# end
