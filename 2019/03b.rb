require_relative 'scaffold'

class Day3b < Scaffold
  test_case "R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83", 610

  C = 11000
  M = 22000

  def set_cell(x, y, wirenum, steps)
    raise [x,y].inspect if @grid[y].nil?

    if @grid[y][x].nil?
      @grid[y][x] = { n: wirenum, s: steps }
    elsif @grid[y][x].is_a?(Hash) && @grid[y][x][:n] == wirenum
      #no
    else
      total_steps = steps + @grid[y][x][:s]

      @cols << [x,y,total_steps] unless x == C && y == C
    end
  end

  def run
    @cols = []
    @grid = Array.new(M) { Array.new(M, nil) }

    wires = input.split("\n")

    wires.each_with_index do |wire, wirenum|
      x,y = C,C
      steps = 0

      wire.split(',').each do |s|
        dir, dist = s.scan(/(.)(.+)/).first
        dist = dist.to_i

        raise [x,y,'oob'].inspect if x < 0 || y < 0

        if dir == ?U
          y.upto(y + dist) { |ny| set_cell(x, ny, wirenum, steps + (ny-y).abs) }
          y = y + dist
        elsif dir == ?D
          y.downto(y - dist) { |ny| set_cell(x, ny, wirenum, steps + (ny-y).abs) }
          y = y - dist
        elsif dir == ?R
          x.upto(x + dist) { |nx| set_cell(nx, y, wirenum, steps + (nx-x).abs) }
          x = x + dist
        elsif dir == ?L
          x.downto(x - dist) { |nx| set_cell(nx, y, wirenum, steps + (nx-x).abs) }
          x = x - dist
        else
          raise 'wat'
        end

        steps += dist
      end
    end

    @cols.transpose.last.min
  end
end
