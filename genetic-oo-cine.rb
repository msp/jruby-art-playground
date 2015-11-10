require_relative "genetic-opal"

attr_reader :genetic
attr_reader :pixel
attr_reader :num_bits

CANVAS = 600

def settings
  # size(CANVAS, CANVAS)
  fullScreen(P3D, 1)
end

def setup
  puts "setup "
  sketch_title 'Genetic OO'
  # frame_rate 5
  background(255)

  @pixel = 100
  @num_bits = width/@pixel * height/@pixel

  p_crossover = 0.98
  p_mutation = 1.0/num_bits*1.5

  @genetic =  Genetic.new(_num_bits: num_bits, _p_crossover: p_crossover, _p_mutation: p_mutation)
end

def draw
  gen = genetic.next_gen()

  xpos = 0
  ypos = 0

  # draw one row
  gen.fetch(:bitstring).each_char do |bit|
    # Off / White + grey border
    if bit.to_i == 0
      fill(255)
      # stroke(200, random(100))
      # line(xpos+ypos, ypos, xpos+pixe, ypos+pixel)
      ellipseMode(CENTER)
      rect(xpos, ypos, random(pixel*2), random(pixel*2), random(7), random(7), random(7), random(7))
    else
      # On / Grey + White border
      # Trends this way
      fill(50, 1)
      # stroke(200)
      no_stroke()
      # ellipseMode(CORNER)
      # ellipse(xpos, ypos, pixel, pixel)
      # line(xpos, ypos+pixel/2, xpos+pixel, ypos)
      # line(xpos, ypos, xpos+pixel+(genetic.generation*0.5), ypos+pixel+(genetic.generation*0.1))

      rect(xpos, ypos, pixel*2, pixel*2)
    end

    if xpos < width
      xpos += pixel
    else
      xpos = 0
      ypos += pixel
    end
  end

  # if @recording
    save_frame("#{File.expand_path(File.dirname(__FILE__))}/output/capture-######.png")
  # end

  # frame_rate(15) if gen.fetch(:fitness) == num_bits
  frame_rate(15) if genetic.generation == 1000
  @recording = false
end

def key_pressed
  return unless key == 'S' || key == 's'
  @recording = true
end
