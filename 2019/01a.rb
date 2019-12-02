require_relative 'scaffold'

class Day1a < Scaffold
  test_case 12, 2
  test_case 14, 2
  test_case 1969, 654
  test_case 100756, 33583

  def run
    input
      .split
      .map(&:to_i)
      .map { |i| (i / 3).floor - 2 }
      .sum
  end
end
