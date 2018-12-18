def run(input)
  $grid = input.split(?\n).map { |l| l.split('') }
  minute = 0
  target = 1_000_000_000

  previous_grids = {}

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

    minute += 1

    if last_time = previous_grids[new_grid]
      number_in_cycle = minute - last_time
      goal_minute = last_time + (target - last_time) % number_in_cycle
      $grid = previous_grids.select { |k,v| v == goal_minute }.first
      return $grid.flatten.count('|') * $grid.flatten.count('#')
    end

    previous_grids[new_grid] = minute
    $grid = new_grid
  end
end

input = File.read("#{File.dirname($0)}/input/#{File.basename($0)[/\d+/]}.txt").chomp
puts run(input)
