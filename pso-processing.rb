require_relative "pso-oo.rb"

attr_reader :algorithm
attr_reader :pixel
attr_reader :num_bits
attr_reader :pixel_multiplier

PIXEL = 20
CANVAS = 800
SEARCH_SPACE_MIN = -5
SEARCH_SPACE_MAX = 5
VEL_SPACE_MIN = -100
VEL_SPACE_MAX = 100

FRAME_RATE = 20
MAX_GENS = 1000
POP_SIZE = 100

def settings
  size(CANVAS, CANVAS)
end

def setup
  sketch_title 'PSO OO'
  frame_rate FRAME_RATE
  background(255)

  # problem configuration
  problem_size = 2
  search_space = Array.new(problem_size) {|i| [SEARCH_SPACE_MIN, SEARCH_SPACE_MAX]}

  # algorithm configuration
  vel_space = Array.new(problem_size) {|i| [VEL_SPACE_MIN, VEL_SPACE_MAX]}

  # execute the algorithm
  @algorithm =  PSO.new(_search_space: search_space, _vel_space: vel_space, _pop_size: POP_SIZE)

  puts "init"
  puts "#"*20
  @algorithm.population.each do |b|
    # puts b.inspect
    draw_pixel(member: b, r:204, g:102, b:0, print_not_draw_for_debug: false)
  end
end

def draw
  background(255)

  # @step = true

  best = @algorithm.search()
  draw_pixel(member: best, size: PIXEL*2, r:0, g:0, b:0)

  puts "[#{frame_count}]after search"
  puts "#"*20
  @algorithm.population.each do |b|
    # puts b.inspect
    draw_pixel(member: b, r:204, g:102, b:0)
  end

  if @recording
    save_frame("#{File.expand_path(File.dirname(__FILE__))}/output/capture-######.png")
  end

  noLoop if MAX_GENS > 0 && frame_count == MAX_GENS
  noLoop if @step

  @recording = false
end

def draw_pixel(member:, size: PIXEL, r:, g:, b:, print_not_draw_for_debug: false)

  m_x_position = member[:b_position] ? member[:b_position][0] : member[:position][0]
  m_y_position = member[:b_position] ? member[:b_position][1] : member[:position][1]

  # m_x_position = member[:position][0]
  # m_y_position = member[:position][1]

  xpos = map1d(m_x_position, (SEARCH_SPACE_MIN..SEARCH_SPACE_MAX), (0..width))
  ypos = map1d(m_y_position, (SEARCH_SPACE_MIN..SEARCH_SPACE_MAX), (0..height))
  location = Vec2D.new(xpos, ypos)

  # if member[:velocity]
  #   xvel = map1d(member[:velocity][0], (SEARCH_SPACE_MIN..SEARCH_SPACE_MAX), (0..width))
  #   yvel = map1d(member[:velocity][1], (SEARCH_SPACE_MIN..SEARCH_SPACE_MAX), (0..height))
  #   velocity = Vec2D.new(xvel, yvel)
  #
  #   location += velocity
  # end


  # puts "x: #{xpos}, y: #{ypos}"

  unless print_not_draw_for_debug
    no_stroke
    fill(r, g, b)
    ellipse(location.x, location.y, size, size)
  end

end

def key_pressed
  puts key
  # return unless key == 'S' || key == 's'
  # @recording = true
  if key == 'R' || key == 'r'
    @pause = !@pause
    @pause ? noLoop : loop
  end

  if key == 'S' || key == 's'
    @step = true
  end
end
