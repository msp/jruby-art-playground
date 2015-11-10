require_relative "genetic-opal"

attr_reader :genetic
attr_reader :pixel
attr_reader :num_bits

CANVAS = 600

def settings
  size(CANVAS, CANVAS)
  #  fullScreen(P3D, 1)
end

def setup
  puts "setup "
  sketch_title 'Genetic OO'
  # frame_rate 15
  background(255)

  @pixel = 10
  @num_bits = width/@pixel * width/@pixel

  p_crossover = 0.98
  p_mutation = 1.0/num_bits*1.5

  @genetic =  Genetic.new(_num_bits: num_bits, _p_crossover: p_crossover, _p_mutation: p_mutation)
  # best = genetic.search()
  # puts "Xdone! Solution: f=#{best[:fitness]}, s=#{best[:bitstring]}"
  # noLoop()

  # smooth(10);
  # hint(ENABLE_STROKE_PURE);
end

def draw
  # puts "draw: #{frame_count} "
  gen = genetic.next_gen()

  xpos = 0
  ypos = 0

  # draw one row
  gen.fetch(:bitstring).each_char do |bit|
    # Off / White + grey border
    if bit.to_i == 0
      fill(255, 1)
      stroke(1, random(10))
      # line(xpos+ypos, ypos, xpos+pixel, ypos+pixel)
      ellipseMode(CENTER)
      strokeWeight(random(15));
      # rect(xpos, ypos, pixel, pixel, random(17), random(17), random(17), random(17))
      # quad(xpos, ypos, xpos+pixel, ypos, xpos+pixel, ypos+pixel, xpos, ypos)
    else
      # On / Grey + White border
      # Trends this way
      fill(201, 1)
      stroke(2, 1)
      # no_stroke()
      # ellipseMode(CORNER)
      # ellipse(xpos, ypos, pixel, pixel)
      # line(xpos, ypos+pixel/2, xpos+pixel, ypos)
      line(xpos, ypos, xpos+pixel+(genetic.generation*0.5), ypos+pixel+(genetic.generation*0.1))

      # rect(xpos, ypos, pixel*2, pixel*2)
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
  frame_rate(15) if genetic.generation == 1000
  @recording = false
end

def key_pressed
  return unless key == 'S' || key == 's'
  @recording = true
end
