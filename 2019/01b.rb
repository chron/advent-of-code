require_relative 'scaffold'

class Day1b < Scaffold
  test_case 14, 2
  test_case 1969, 966
  test_case 100756, 50346

  def run
    input
      .split
      .map(&:to_i)
      .map { |i| calc_module(i) }
      .sum
  end

  def calc_module(i, t=0)
    r = (i / 3).floor - 2

    r > 0 ? calc_module(r, r+t) : t
  end
end
