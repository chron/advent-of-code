def run(input)
  $serial = input.to_i

  grid = Array.new(301) { [] }

  1.upto(300) do |y|
    1.upto(300) do |x|
      grid[x][y] = power_at(x,y)
    end
  end

  largest = 0
  lv = []

  #p grid.map { |r| r.join(' ') }

  1.upto(298) do |y|
    1.upto(298) do |x|
      v = grid[x][y] + grid[x + 1][y] + grid[x + 2][y] + grid[x][y + 1] + grid[x + 1][y + 1] + grid[x + 2][y + 1] + grid[x][y + 2] + grid[x + 1][y + 2] + grid[x + 2][y + 2]
      if v > largest
        largest = v
        lv = [x, y]
      end
    end
  end

  lv * ','
end

def power_at(x,y)
  rack_id = x + 10

  p = rack_id * y
  p += $serial
  p *= rack_id

  p.digits[2] - 5
end

input = File.read("#{File.dirname($0)}/input/#{File.basename($0)[/\d+/]}.txt").chomp
puts run(input)
