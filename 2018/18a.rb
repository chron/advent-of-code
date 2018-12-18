def run(input)
  $grid = input.split(?\n).map { |l| l.split('') }
  minute = 0

  loop do
    new_grid = []

    0.upto($grid.length - 1) do |y|
      0.upto($grid.length - 1) do |x|
        new_grid[y] ||= []

        neighbors = [
          [x,y-1],
          [x,y+1],
          [x+1,y-1],
          [x+1,y],
          [x+1,y+1],
          [x-1,y-1],
          [x-1,y],
          [x-1,y+1],
        ].map { |dx,dy| $grid[dy][dx] if dy >= 0 && dx >= 0 && dy < $grid.length && dx < $grid.length }.compact

        if $grid[y][x] == '.'
          if neighbors.count('|') >= 3
            new_grid[y][x] = '|'
          else
            new_grid[y][x] = '.'
          end
        elsif $grid[y][x] == '|'
          if neighbors.count('#') >= 3
            new_grid[y][x] = '#'
          else
            new_grid[y][x] = '|'
          end
        elsif $grid[y][x] == '#'
          if (neighbors.count('#') >= 1) && (neighbors.count('|') >= 1)
            new_grid[y][x] = '#'
          else
            new_grid[y][x] = '.'
          end
        end
      end
    end

    $grid = new_grid
    minute += 1
    break if minute >= 10
  end

  $grid.flatten.count('|') * $grid.flatten.count('#')
end

test_cases = [
['.#.#...|#.
.....#|##|
.|..|...#.
..|#.....#
#.#|||#|#|
...#.||...
.|....|...
||...#|.#|
|.||||..|.
...#.|..|.',  1147]
]

test_cases.each_with_index do |(input, output), index|
  raise "Test case #{index + 1} failed!" if run(input) != output
end

input = File.read("#{File.dirname($0)}/input/#{File.basename($0)[/\d+/]}.txt").chomp
puts run(input)
