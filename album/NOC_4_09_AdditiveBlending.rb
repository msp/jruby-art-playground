#  NOC_4_09_AdditiveBlending
# The Nature of Code
# http://natureofcode.com
require_relative 'particle_system'
# require_relative 'particle'

attr_reader :ps

def setup
  sketch_title 'Additive Blending'
  # frame_rate(25)
  @ps = ParticleSystem.new(number: 0, origin: Vec2D.new(width / 2, 0))
  noise_seed(100)
end

def draw
  # puts frame_count
  blend_mode(ADD)
  background(0)
  ps.run
  x = random(width)
  y = random(height)


  if frame_count % 1 == 0
    1.times { ps.add_particle(Particle.new(location: Vec2D.new(x,y), image: ps.img)) }
    # 1.times { ps.add_particle }
  end

  if @recording
    save_frame("#{File.expand_path(File.dirname(__FILE__))}/output/capture-######.png")
  end

  # frame_rate(15) if gen.fetch(:fitness) == num_bits
  # frame_rate(15) if genetic.generation == 1000
  # no_loop if genetic.generation == MAX
  @recording = false
end

def settings
  size(640, 340, P2D)
  fullScreen(2)
end

class Particle
  include Processing::Proxy
  attr_reader :acceleration, :lifespan, :location, :velocity, :t, :n

  def initialize(location:, image:)
    @acceleration = Vec2D.new(0, 0.005)
    @velocity = Vec2D.new(rand(-1.0..10), rand(-1.0..0))
    @velocity *= 0.5
    @location = location
    @img = image
    @lifespan = 255.0
    @t = 0.0
  end

  def run
    update
    render
  end

  # Method to update location
  def update
    @n = noise(@t)
    @velocity += acceleration
    # @location += velocity

    x = velocity.x + random(width/200)
    # x = width/2 + velocity.x + @n

    # x = velocity.x + width/2 + @n * 200
    # x = map1d(@n, 0..1, 0..width)

    y = map1d(@n, 0..1, 0..height)

    @location = Vec2D.new(x, y)
    # puts "#{@location.x}:#{@location.y}"

    @lifespan -= 0.1
    @t += 0.01

  end


  # Method to display
  def render
    image_mode(CENTER)
    tint(lifespan/10)
    # fill(lifespan/2)
    fill(0)

    # with rect
    # stroke(255.0 - lifespan)
    # stroke_width(map1d(@n, 0..1, 2..50))

    # with line
    stroke(255.0, map1d(@n, 0..1, 2..50))
    stroke_width(map1d(@n, 0..1, 2..5))
    # stroke(map1d(@n, 0..1, 0..255))
    # image(@img, location.x, location.y)
    # size = Vec2D.new(rand(0..width/2), rand(0..height/2))

    # size = Vec2D.new(width/2, height/20)
    # size = Vec2D.new(rand(0..width/2), height/200)
    # , dimension: Vec2D.new(width/2, pixel_size))

    # pixel_size = random(width/5)
    pixel_size = map1d(@n, 0..1, 0..width/2)
    # pixel_size = 20


    rect(location.x, location.y, pixel_size, 20)
    # line(location.x, location.y, width - location.x, height - location.y)
  end

  # Is the particle still useful?
  def dead?
    lifespan < 0.0
  end
end

def key_pressed
  puts "MSPX key: #{key}"
  @recording = true if key == 'S' || key == 's'
  no_loop if key == 'p'
  loop if key == 'r'
  @shape_mode = 'rect' if key == 'w'
  @shape_mode = 'quad' if key == 'q'
  @pixel += 1 if key == '='
  @pixel -= 1 if key == '-'
  @cls = true if key == 'c'
end
