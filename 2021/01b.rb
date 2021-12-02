require_relative 'scaffold'

class Day1b < Scaffold
  def run
    input.split.map(&:to_i).each_cons(3).map { |v| v.sum }.each_cons(2).count { |a,b| b > a}
  end
end
