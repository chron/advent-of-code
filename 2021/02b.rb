require_relative 'scaffold'

class Day2a < Scaffold
  test_case 'forward 5
    down 5
    forward 8
    up 3
    down 8
    forward 2', 900

  def run
    aim = 0
    horiz = 0
    depth = 0

    lines.each do |line|
      dir, a = line.split(' ')
      amt = a.to_i

      case(dir)
        when 'up'
          aim -= amt
        when 'down'
          aim += amt
        when 'forward'
          horiz += amt
          depth += aim * amt
        else
          raise "Unknown direction #{dir}"
      end
    end

    horiz * depth
  end
end
