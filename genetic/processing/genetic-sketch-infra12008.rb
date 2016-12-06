require_relative "../ruby/genetic-opal"

attr_reader :genetic
attr_reader :pixel
attr_reader :num_bits

CANVAS = 1000
MAX = 10000

def settings
  size(CANVAS, CANVAS)
  fullScreen(2)
  pixelDensity(displayDensity())
end

def setup
  puts "setup "
  sketch_title 'Genetic OO'
  frame_rate 8r
  # background(255)
  @shape_mode = 'quad'

  @pixel = 200
  @num_bits = width/@pixel * height/@pixel

  p_crossover = 0.98
  p_mutation = 1.0/num_bits

  @genetic =  Genetic.new(_num_bits: num_bits, _p_crossover: p_crossover, _p_mutation: p_mutation)
  # best = genetic.search()
  # puts "Xdone! Solution: f=#{best[:fitness]}, s=#{best[:bitstring]}"
  # noLoop()

  @mspAlphaCounter = 0
  @totalAlphaFrames = 50
  @forward = true

end

def draw
  # fade the background by giving it a low opacity
  # background(0, 50);

  # lights
  # puts "draw: #{frame_count} "
  gen = genetic.next_gen()

  xpos = 0
  ypos = 0

  if @mspAlphaCounter == @totalAlphaFrames
      @mspAlphaCounter = 0
      @forward = !@forward
  else
      @mspAlphaCounter += 1
  end

  background(255) if @cls

  # draw one row
  gen.fetch(:bitstring).each_char do |bit|
    # Off / White + grey border
    if bit.to_i == 0
      @pixel = 8

      if @forward
          lower = 0.7
          upper = 0.0
      else
          lower = 0.0
          upper = 0.7
      end

      alpha = map1d(@mspAlphaCounter, (0..@totalAlphaFrames), (lower..upper))
      stroke(random(255))
      strokeWeight(1)

      line(ypos, xpos, xpos + pixel + (frame_count * 2), xpos + pixel + (frame_count * 1))

    else
      # On / Grey + White border
      # Trends this way
      if @pixel > 10000
          @pixel = 5
      else
          # pixel = pixel * 0.5;
          @pixel = @pixel * 1.2
      end

      alpha = map1d(randomGaussian(), 0..1, 0..255)
      alpha = 5 if alpha < 5

      stroke(204, 204, 220, alpha)
      # stroke(204, 204, 220)
      fill(224, 224, 220, alpha)
      strokeWeight(random(15));

      if frame_count % 5 == 0
          drawQuadVertexRect(xpos+random(51), ypos+random(51))
      else
          rect(xpos + random(51), ypos + random(51), random(pixel), random(pixel), random(7), random(7), random(7), random(7))
      end
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
