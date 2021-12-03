require_relative 'scaffold'

class Day2a < Scaffold
  test_case 'forward 5
    down 5
    forward 8
    up 3
    down 8
    forward 2', 150

  def run
    horiz = 0
    depth = 0

    lines.each do |line|
      dir, a = line.split(' ')
      amt = a.to_i

      case(dir)
        when 'up'
          depth -= amt
        when 'down'
          depth += amt
        when 'forward'
          horiz += amt
        else
          raise "Unknown direction #{dir}"
      end
    end

    horiz * depth
  end
end
