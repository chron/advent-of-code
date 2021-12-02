require_relative 'scaffold'

class Day1a < Scaffold
  def run
    input.split.each_cons(2).count { |a, b| b.to_i > a.to_i }
  end
end
