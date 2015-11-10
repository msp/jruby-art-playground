# Genetic Algorithm in the Ruby Programming Language

# The Clever Algorithms Project: http://www.CleverAlgorithms.com
# (c) Copyright 2010 Jason Brownlee. Some Rights Reserved.
# This work is licensed under a Creative Commons Attribution-Noncommercial-Share Alike 2.5 Australia License.

# http://www.cleveralgorithms.com/nature-inspired/evolution/genetic_algorithm.html

#
# MSP - this will transpile in Opal
#
class Genetic
  attr_reader :num_bits
  attr_reader :max_gens
  attr_reader :pop_size
  attr_reader :p_crossover
  attr_reader :p_mutation
  attr_accessor :generation
  attr_accessor :population

  def initialize(_num_bits: 64, _max_gens: 100, _pop_size: 100, _p_crossover: , _p_mutation:)
    @num_bits = _num_bits
    @max_gens = _max_gens
    @pop_size = _pop_size
    @p_crossover = _p_crossover
    @p_mutation = _p_mutation

    @generation = 0
    @population = Array.new(pop_size) do |i|
      {:bitstring => random_bitstring(num_bits)}
    end
  end

  def next_gen()
    population.each { |c| c[:fitness] = onemax(c[:bitstring]) }
    best = population.sort { |x, y| y[:fitness] <=> x[:fitness] }.first

    selected = Array.new(pop_size) { |i| binary_tournament(population) }
    children = reproduce(selected, pop_size, p_crossover, p_mutation)
    children.each { |c| c[:fitness] = onemax(c[:bitstring]) }
    children.sort! { |x, y| y[:fitness] <=> x[:fitness] }
    best = children.first if children.first[:fitness] >= best[:fitness]
    @population = children
    puts " > gen #{generation}, best: #{best[:fitness]}, #{best[:bitstring]}"
    # puts " > gen #{generation}, best: #{best[:fitness]}"

    @generation += 1
    return best
  end


  def search()
    population.each { |c| c[:fitness] = onemax(c[:bitstring]) }
    best = population.sort { |x, y| y[:fitness] <=> x[:fitness] }.first
    max_gens.times do |gen|
      selected = Array.new(pop_size) { |i| binary_tournament(population) }
      children = reproduce(selected, pop_size, p_crossover, p_mutation)
      children.each { |c| c[:fitness] = onemax(c[:bitstring]) }
      children.sort! { |x, y| y[:fitness] <=> x[:fitness] }
      best = children.first if children.first[:fitness] >= best[:fitness]
      population = children
      puts " > gen #{gen}, best: #{best[:fitness]}, #{best[:bitstring]}"
      break if best[:fitness] == num_bits
    end
    return best
  end

  private
  def onemax(bitstring)
    sum = 0
    bitstring.size.times { |i| sum+=1 if bitstring[i].chr=='1' }
    return sum
  end

  def random_bitstring(num_bits)
    return (0...num_bits).inject("") { |s, i| s = s + ((rand<0.5) ? "1" : "0") }
  end

  def binary_tournament(pop)
    i, j = rand(pop.size), rand(pop.size)
    j = rand(pop.size) while j==i
    return (pop[i][:fitness] > pop[j][:fitness]) ? pop[i] : pop[j]
  end

  def point_mutation(bitstring, rate=1.0/bitstring.size)
    child = ""
    bitstring.size.times do |i|
      bit = bitstring[i].chr
      child = child + ((rand()<rate) ? ((bit=='1') ? "0" : "1") : bit)
    end
    return child
  end

  def crossover(parent1, parent2, rate)
    return ""+parent1 if rand()>=rate
    point = 1 + rand(parent1.size-2)
    return parent1[0...point]+parent2[point...(parent1.size)]
  end

  def reproduce(selected, pop_size, p_cross, p_mutation)
    children = []
    selected.each_with_index do |p1, i|
      p2 = (i.modulo(2)==0) ? selected[i+1] : selected[i-1]
      p2 = selected[0] if i == selected.size-1
      child = {}
      child[:bitstring] = crossover(p1[:bitstring], p2[:bitstring], p_cross)
      child[:bitstring] = point_mutation(child[:bitstring], p_mutation)
      children << child
      break if children.size >= pop_size
    end
    return children
  end

end

max = 99
pixel = 50
num_bits = 300/pixel * 300/pixel

p_crossover = 0.98
p_mutation = 1.0/num_bits*1.5

genetic =  Genetic.new(_num_bits: num_bits, _p_crossover: p_crossover, _p_mutation: p_mutation)

(0..max).each do
  genetic.next_gen()
end

