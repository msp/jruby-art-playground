# Particle Swarm Optimization in the Ruby Programming Language

# The Clever Algorithms Project: http://www.CleverAlgorithms.com
# (c) Copyright 2010 Jason Brownlee. Some Rights Reserved.
# This work is licensed under a Creative Commons Attribution-Noncommercial-Share Alike 2.5 Australia License.

class PSO

  attr_reader :search_space
  attr_reader :vel_space
  attr_reader :max_gens
  attr_reader :pop_size
  attr_reader :max_vel
  attr_reader :c1
  attr_reader :c2
  attr_reader :population
  attr_reader :gbest

  def initialize(_search_space:, _vel_space:, _max_gens: 100, _pop_size: 50, _max_vel: 100.0, _c1: 2.0, _c2: 2.0)
    @search_space = _search_space
    @vel_space = _vel_space
    @max_gens = _max_gens
    @pop_size = _pop_size
    @max_vel = _max_vel
    @c1 = _c1
    @c2 = _c2

    @population = Array.new(pop_size) {create_particle(search_space, vel_space)}
    @gbest = get_global_best()
    # @population.map {|p| puts p}
    # @pop.map {|p| puts "co-ords: x: #{p[:position][0].round(4)}, y: #{p[:position][1].round(4)}
    #                       || x100: #{(p[:position][0]*100).round(4)}, y100: #{(p[:position][1]*100).round(4)}" }
  end

  def search()
    # gbest = get_global_best(population)
    # max_gens.times do |gen|
        population.each do |particle|
          update_velocity(particle, gbest, max_vel, c1, c2)
          update_position(particle, search_space)
          particle[:cost] = objective_function(particle[:position])
          update_best_position(particle)
          # puts "MSP #{particle.inspect}"
        end
      gbest = get_global_best(gbest)
      # puts " > gen #{gen+1}, fitness=#{gbest[:cost]}"
    # end

    # puts "done! Solution: f=#{gbest[:cost]}, s=#{gbest[:position].inspect}"

    return gbest
  end

  def get_global_best(current_best=nil)
    population.sort!{|x,y| x[:cost] <=> y[:cost]}
    best = population.first
    if current_best.nil? or best[:cost] <= current_best[:cost]
      current_best = {}
      current_best[:position] = Array.new(best[:position])
      current_best[:cost] = best[:cost]
    end
    return current_best
  end


  private

  def objective_function(vector)
    return vector.inject(0.0) {|sum, x| sum +  (x ** 2.0)}
  end

  def random_vector(minmax)
    return Array.new(minmax.size) do |i|
      minmax[i][0] + ((minmax[i][1] - minmax[i][0]) * rand())
    end
  end

  def create_particle(search_space, vel_space)
    particle = {}
    particle[:position] = random_vector(search_space)
    particle[:cost] = objective_function(particle[:position])
    particle[:b_position] = Array.new(particle[:position])
    particle[:b_cost] = particle[:cost]
    particle[:velocity] = random_vector(vel_space)
    return particle
  end

  def update_velocity(particle, gbest, max_v, c1, c2)
    particle[:velocity].each_with_index do |v,i|
      v1 = c1 * rand() * (particle[:b_position][i] - particle[:position][i])
      v2 = c2 * rand() * (gbest[:position][i] - particle[:position][i])
      particle[:velocity][i] = v + v1 + v2
      particle[:velocity][i] = max_v if particle[:velocity][i] > max_v
      particle[:velocity][i] = -max_v if particle[:velocity][i] < -max_v
    end
  end

  def update_position(part, bounds)
    part[:position].each_with_index do |v,i|
      part[:position][i] = v + part[:velocity][i]
      if part[:position][i] > bounds[i][1]
        part[:position][i]=bounds[i][1]-(part[:position][i]-bounds[i][1]).abs
        part[:velocity][i] *= -1.0
      elsif part[:position][i] < bounds[i][0]
        part[:position][i]=bounds[i][0]+(part[:position][i]-bounds[i][0]).abs
        part[:velocity][i] *= -1.0
      end
    end
  end

  def update_best_position(particle)
    return if particle[:cost] > particle[:b_cost]
    particle[:b_cost] = particle[:cost]
    particle[:b_position] = Array.new(particle[:position])
  end

end

puts __FILE__
puts $0
if __FILE__ == $0
  # problem configuration
  problem_size = 2
  # search_space = Array.new(problem_size) {|i| [-5, 5]}
  search_space = Array.new(problem_size) {|i| [0, 5]}

  # algorithm configuration
  vel_space = Array.new(problem_size) {|i| [-1, 1]}
  puts "search_space: #{search_space}"
  puts "vel_space: #{vel_space}"

  # execute the algorithm
  pso = PSO.new(_search_space: search_space, _vel_space: vel_space)
  pso.search()
end
