require_relative "../ruby/genetic-opal"

attr_reader :genetic
attr_reader :pixel
attr_reader :num_bits

CANVAS = 601
MAX = 10000

def settings
  # size(CANVAS, CANVAS)
  fullScreen(P3D, 2)
  pixelDensity(displayDensity())
end

def setup
  puts "setup "
  sketch_title 'Genetic OO'
  # frame_rate 5
  background(255)
  @shape_mode = 'quad'

  @pixel = 200
  @num_bits = width/@pixel * height/@pixel

  p_crossover = 0.98
  p_mutation = 1.0/num_bits

  @genetic =  Genetic.new(_num_bits: num_bits, _p_crossover: p_crossover, _p_mutation: p_mutation)
  # best = genetic.search()
  # puts "Xdone! Solution: f=#{best[:fitness]}, s=#{best[:bitstring]}"
  # noLoop()
end

def draw
  # lights
  # puts "draw: #{frame_count} "
  gen = genetic.next_gen()

  xpos = 0
  ypos = 0

  background(255) if @cls

  # draw one row
  gen.fetch(:bitstring).each_char do |bit|
    # Off / White + grey border
    if bit.to_i == 0
      stroke(204, 102, 0, 1)
      # stroke(204, 102, 0, 10)
      # stroke(250, 10)
      # stroke_cap(ROUND)
      stroke_weight(1000)
      # strokeWeight(random(1000))
      # line(ypos, xpos, xpos+pixel+(genetic.generation/2), ypos+pixel+(genetic.generation*0.1))

      line(xpos, ypos, ypos+pixel+(genetic.generation/2), xpos+pixel+(genetic.generation*0.1))

    else
      # On / Grey + White border
      # Trends this way

      # fill(50, 1)
      # stroke(0, 1)
      stroke(10)
      # strokeWeight(genetic.generation/2)
      strokeWeight(1)

      line(xpos, ypos, ypos+pixel+(genetic.generation/2), xpos+pixel+(genetic.generation*0.1))
      # rect(xpos, ypos, pixel, pixel)
      # rect(xpos+random(51), ypos+random(51), random(pixel), random(pixel), random(7), random(7), random(7), random(7))

      # translate(xpos, ypos, 0);
      # rotateY(0.5);
      # box(pixel/2);
    end

    if xpos < width
      xpos += pixel
    else
      xpos = 0
      ypos += pixel
    end
  end

  if @recording
    save_frame("#{File.expand_path(File.dirname(__FILE__))}/output/capture-######.png")
  end

  # frame_rate(15) if gen.fetch(:fitness) == num_bits
  # frame_rate(15) if genetic.generation == 1000
  # no_loop if genetic.generation == MAX
  @recording = false
end

def drawQuadVertexRect(xpos, ypos)
  r_amt = 0
  br_amt = 0
  # quad_height = random(pixel/2, pixel)
  # quad_width = random(pixel/2, pixel)
  quad_height = pixel
  quad_width = pixel

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
  @recording = true if key == 'S' || key == 's'
  no_loop if key == 'p'
  loop if key == 'r'
  @shape_mode = 'rect' if key == 'w'
  @shape_mode = 'quad' if key == 'q'
  @pixel += 1 if key == '='
  @pixel -= 1 if key == '-'
  @cls = true if key == 'c'
end
