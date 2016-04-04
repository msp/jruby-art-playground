require_relative "../ruby/genetic-opal"

attr_reader :genetic
attr_reader :pixel
attr_reader :num_bits

CANVAS = 600

def settings
  size(CANVAS, CANVAS)
end

def setup
  puts "setup "
  sketch_title 'Genetic OO'
  # frame_rate 5
  background(255)

  @pixel = 30
  @num_bits = CANVAS/@pixel * CANVAS/@pixel

  p_crossover = 0.98
  # cine squares
  # p_mutation = 1.0/num_bits*1.5
  # control
  p_mutation = 1.0/num_bits

  @genetic =  Genetic.new(_num_bits: num_bits, _p_crossover: p_crossover, _p_mutation: p_mutation)
  # best = genetic.search()
  # puts "Xdone! Solution: f=#{best[:fitness]}, s=#{best[:bitstring]}"
  # noLoop()
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
      fill(255)
      # stroke(200, random(100))
      # line(xpos+ypos, ypos, xpos+pixe, ypos+pixel)
      # ellipseMode(CENTER)
      # quad(xpos, ypos, xpos+pixel, ypos, xpos+pixel, ypos+pixel, xpos, ypos)

      # cine squares
      # rect(xpos, ypos, random(pixel*2), random(pixel*2), random(7), random(7), random(7), random(7))

      # control
      rect(xpos, ypos, pixel, pixel)
    else
      # On / Grey + White border
      # Trends this way

      # cine squares
      # fill(50, 1)

      # control
      fill(50)
      # stroke(200)
      no_stroke()
      # ellipseMode(CORNER)
      # ellipse(xpos, ypos, pixel, pixel)
      # line(xpos, ypos+pixel/2, xpos+pixel, ypos)
      # line(xpos, ypos, xpos+pixel+(genetic.generation*0.5), ypos+pixel+(genetic.generation*0.1))

      # cine squares
      # rect(xpos, ypos, pixel*2, pixel*2)

      # control
      rect(xpos, ypos, pixel, pixel)
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
