def run(input)
  coords = input.split("\n").map.with_index { |l,i| [i, l.split(',').map(&:to_i)] }

  grid = Array.new(600) { Array.new(600, nil) }

  grid.each_index do |x|
    grid[x].each_index do |y|
      close_coords = coords.map { |n,(cx,cy)| [n, manhattan(x,y,cx+100,cy+100)] }.sort_by { |k,v| v }

      if close_coords[0][1] != close_coords[1][1]
        grid[x][y] = close_coords.first.first
      end
    end
  end

  finite_coords = coords.reject { |c,p| [grid[0],grid[-1],grid.map(&:first),grid.map(&:last)].flatten.any? { |v| v == c }}

  v = finite_coords.map { |c,_| grid.flatten.count(c) }
  p v.sort
  v.max
end

def manhattan(x1,y1,x2,y2)
  (x1 - x2).abs + (y1 - y2).abs
end

test_cases = [
  ['1, 1
    1, 6
    8, 3
    3, 4
    5, 5
    8, 9', 17]
]

test_cases.each_with_index do |(input, output), index|
  raise "Test case #{index + 1} failed!" if run(input) != output
end

input = File.read("#{File.dirname($0)}/input/#{File.basename($0)[/\d+/]}.txt").chomp
puts run(input)
