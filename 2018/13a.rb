def run(input)
  lines = input.split("\n")
  max_len = lines.map { |l| l.length }.max

  grid = lines.map { |l| l.ljust(max_len).split('') }
  trains = []

  0.upto(grid.length - 1) do |y|
    0.upto(max_len - 1) do |x|
      c = grid[y][x]

      if c == ?>
        trains << [x,y,1,0]
        grid[y][x] = ?-
      elsif c == ?<
        trains << [x,y,3,0]
        grid[y][x] = ?-
      elsif c == ?^
        trains << [x,y,0,0]
        grid[y][x] = ?|
      elsif c == ?v
        trains << [x,y,2,0]
        grid[y][x] = ?|
      end
    end
  end

  tick = 0

  loop do
    trains.map! do |x,y,direction,next_choice|
      dx,dy = [[0,-1], [1,0], [0,1], [-1,0]][direction]

      next_cell = [x+dx,y+dy]
      next_tile = grid[y+dy][x+dx]
      future_choice = next_choice

      if [?|, ?-].include?(next_tile)
        next_direction = direction
      elsif next_tile == '/'
        next_direction = case direction
          when 0 then 1
          when 1 then 0
          when 2 then 3
          when 3 then 2
        end
      elsif next_tile == '\\'
        next_direction = case direction
          when 0 then 3
          when 3 then 0
          when 1 then 2
          when 2 then 1
        end
      elsif next_tile == ?+
        next_direction = (direction + [3, 0, 1][future_choice]) % 4
        future_choice = (future_choice + 1) % 3
      else
        raise "what is #{next_tile}"
      end

      if trains.any? { |ox,oy,_,_| [ox,oy] == next_cell }
        return next_cell*','
      end

      [*next_cell, next_direction, future_choice]
    end

    tick += 1
  end
end

test_cases = [
['/->-\
|   |  /----\
| /-+--+-\  |
| | |  | v  |
\-+-/  \-+--/
  \------/   ', '7,3']
]

test_cases.each_with_index do |(input, output), index|
  raise "Test case #{index + 1} failed!" if run(input) != output
end

input = File.read("#{File.dirname($0)}/input/#{File.basename($0)[/\d+/]}.txt").chomp
puts run(input)
