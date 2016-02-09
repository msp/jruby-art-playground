load_libraries 'pdf'
include_package 'processing.pdf'


require 'benchmark'
require_relative 'genetic-opal'

attr_reader :genetic
attr_reader :pixel
attr_reader :num_bits

CANVAS = 1000
MAX_GENS = 220
# get the animation right, the mulitply the canvas by SCALER
# and call scale(SCALER) in draw(), copying to an off screen buffer
# SCALER = 300/72
SCALER = 3

def settings
  # size(CANVAS*SCALER, CANVAS*SCALER, P3D)
  size(CANVAS*SCALER, CANVAS*SCALER, PDF, "#{File.expand_path(File.dirname(__FILE__))}/output/capture-hires-#{Time.now.to_i}.pdf")
  # fullScreen(P3D, 0)
  pixelDensity(displayDensity())
end

def setup
  puts "setup "
  sketch_title 'Genetic OO'
  # frame_rate 5
  background(255)
  @shape_mode = 'quad'

  @pixel = 80
  @num_bits = width/@pixel * height/@pixel

  p_crossover = 0.98
  p_mutation = 1.0/num_bits*1.5

  @genetic = Genetic.new(_num_bits: num_bits, _p_crossover: p_crossover, _p_mutation: p_mutation, _pop_size: 100)
end

def draw
  puts "draw #{genetic.generation} w #{width} h #{height}"
  xpos = 0
  ypos = 0

  background(255) if @cls

  # quick
  gen = genetic.next_gen()

  # slow
  gen.fetch(:bitstring).each_char do |bit|
    # Off / White + grey border
    if bit.to_i == 0
      # fill(150, 100)

      stroke(55, random(100))
      # stroke(0)

      # line(xpos+ypos, ypos, xpos+pixel, ypos+pixel)

      if @shape_mode == 'rect'
        rect(xpos+random(51), ypos+random(51), random(pixel), random(pixel), random(7), random(7), random(7), random(7))
      elsif @shape_mode == 'quad'
        drawQuadVertexRect(xpos+random(51), ypos+random(51))
      end
    else
      # On / Grey + White border
      # Trends this way
      fill(255,1)
      stroke(255)
      # no_stroke()
      # ellipseMode(CORNER)
      # ellipse(xpos, ypos, pixel, pixel)
      # line(xpos, ypos+pixel/2, xpos+pixel, ypos)
      # line(xpos, ypos, xpos+pixel+(genetic.generation*0.5), ypos+pixel+(genetic.generation*0.1))

      # rect(xpos, ypos, pixel, pixel)
      if @shape_mode == 'rect'
        rect(xpos+random(51), ypos+random(51), random(pixel), random(pixel), random(7), random(7), random(7), random(7))
      elsif @shape_mode == 'quad'
        drawQuadVertexRect(xpos+random(51), ypos+random(51))
      end
    end

    if xpos < width
      xpos += pixel
    else
      xpos = 0
      ypos += pixel
    end

    # to test a custom shape
    # xpos = pixel*2
    # ypos = pixel*2
    # stroke(0)
    # drawQuadVertexRect(xpos, ypos)

  end

  if @recording
    save_frame("#{File.expand_path(File.dirname(__FILE__))}/output/capture-######.png")
  end

  # puts "MSPX frame_rate: #{frame_rate}"
  # frame_rate(15) if gen.fetch(:fitness) == num_bits
  exit if genetic.generation == MAX_GENS
  @recording = false
  @cls = false
end

def drawQuadVertexRect(xpos, ypos)
  r_amt = 0
  br_amt = 0
  quad_height = random(pixel/2, pixel)
  quad_width = random(pixel/2, pixel)
  # quad_height = pixel
  # quad_width = pixel

  x1 = xpos+random(r_amt)
  y1 = ypos+random(r_amt)

  x2 = xpos+(quad_width)+random(r_amt)
  y2 = ypos+random(r_amt)

  x3 = xpos+(quad_width)+random(r_amt)
  y3 = ypos+(quad_height)+random(r_amt)

  x4 = xpos+random(r_amt)
  y4 = ypos+(quad_height)+random(r_amt)

  # quad(x1, y1, x2, y2, x3, y3, x4, y4) b
  beginShape
  vertex(x1, y1)
  quadraticVertex(x2-pixel/2, y2-pixel/5+random(br_amt), x2, y2)
  quadraticVertex(x3+pixel/5+random(br_amt), y3-pixel/5, x3, y3)
  quadraticVertex(x4+pixel/5, y4+pixel/5+random(br_amt), x4, y4)
  quadraticVertex(x1-pixel/5+random(br_amt), y1+pixel/5, x1, y1)
  endShape()
end

def key_pressed
  puts "MSPX key: #{key}"

  if (key == 'S' || key == 's')
    @recording = true
    # capture_hi_res_using_buffer
  end

  no_loop if key == 'p'
  loop if key == 'r'
  @shape_mode = 'rect' if key == 'w'
  @shape_mode = 'quad' if key == 'q'
  @pixel += 1 if key == '='
  @pixel -= 1 if key == '-'
  @cls = true if key == 'c'
end

def capture_hi_res_using_buffer
  @recording = false
  pg = create_graphics((width*SCALER).to_i, (height*SCALER).to_i, P3D)
  # pg.pixelDensity(displayDensity())
  pg.begin_draw()
  pg.load_pixels()
  # puts "MSPX pg: #{pg.pixels.length}"
  # puts "MSPX self.g.pixels: #{self.g.pixels.length}"

  pg.pixels = self.g.pixels

  pg.update_pixels()
  pg.save("#{File.expand_path(File.dirname(__FILE__))}/output/capture-hires-#{Time.now.to_i}.png")
  pg.end_draw()
end
