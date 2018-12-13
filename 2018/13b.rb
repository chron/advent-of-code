Train = Struct.new(:x, :y, :direction, :next_choice, :dead, :newly_dead)

def run(input)
  lines = input.split("\n")
  max_len = lines.map { |l| l.length }.max

  grid = lines.map { |l| l.ljust(max_len).split('') }
  trains = []

  0.upto(grid.length - 1) do |y|
    0.upto(max_len - 1) do |x|
      c = grid[y][x]

      if c == ?>
        trains << Train.new(x,y,1,0)
        grid[y][x] = ?-
      elsif c == ?<
        trains << Train.new(x,y,3,0)
        grid[y][x] = ?-
      elsif c == ?^
        trains << Train.new(x,y,0,0)
        grid[y][x] = ?|
      elsif c == ?v
        trains << Train.new(x,y,2,0)
        grid[y][x] = ?|
      end
    end
  end

  tick = 0

  loop do
    trains.sort_by { |t| [t.y, t.x] }.each do |train|
      next if train.dead

      dx,dy = [[0,-1], [1,0], [0,1], [-1,0]][train.direction]

      next_x = train.x+dx
      next_y = train.y+dy
      next_tile = grid[next_y][next_x]
      future_choice = train.next_choice

      if [?|, ?-].include?(next_tile)
        next_direction = train.direction
      elsif next_tile == '/'
        next_direction = case train.direction
          when 0 then 1
          when 1 then 0
          when 2 then 3
          when 3 then 2
        end
      elsif next_tile == '\\'
        next_direction = case train.direction
          when 0 then 3
          when 3 then 0
          when 1 then 2
          when 2 then 1
        end
      elsif next_tile == ?+
        next_direction = (train.direction + [3, 0, 1][future_choice]) % 4
        future_choice = (future_choice + 1) % 3
      end

      train.x = next_x
      train.y = next_y
      train.direction = next_direction
      train.next_choice = future_choice

      colliding_trains = trains.select { |other| train != other && !other.dead && other.x == train.x && other.y == train.y }

      if colliding_trains.any?
        colliding_trains.each { |t| t.dead = true }
        train.dead = true
      end
    end

    tick += 1

    alive_trains = trains.reject(&:dead)
    return [alive_trains[0].x, alive_trains[0].y] * ',' if alive_trains.length == 1
  end
end

test_cases = [
'/>-<\
|   |
| /<+-\
| | | v
\>+</ |
  |   ^
  \<->/', '6,4'
]

test_cases.each_with_index do |(input, output), index|
  #raise "Test case #{index + 1} failed!" if run(input) != output
end

input = File.read("#{File.dirname($0)}/input/#{File.basename($0)[/\d+/]}.txt").chomp
puts run(input)
