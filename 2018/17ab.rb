def run(input)
  $grid = Array.new(2100) { Array.new(800, '.') }

  $max_y = 0
  $max_x = 0
  $min_y = 1000

  input.split(?\n).each do |l|
    h = eval("{#{l.tr('=', ':')}}")
    [*h[:y]].each do |yv|
      $max_y = [$max_y, yv].max
      $min_y = [$min_y, yv].min

      [*h[:x]].each do |xv|
        $max_x = [$max_x, xv].max
        $grid[yv] ||= []
        $grid[yv][xv] = '#'
      end
    end
  end

  $water = 1
  water_before = 0
  $wa = [[500,0]]

  same = 0
  $grid[0][500] = '|'

  loop {
    iterate

    if $water == water_before
      same += 1
    else
      same = 0
      water_before = $water
    end

    break if same > 3
  }

  #print_grid

  puts $wa.count { |x,y| $grid[y][x] == '~' } # part b

  $water - $wa.count { |x,y| y < $min_y || y > $max_y } # THIS TOOK ME SO LONG TO FIGURE OUT WTF
end

def iterate
  $wa.each do |x,y|
    cell = $grid[y][x]

    if cell == '|'
      if y > $max_y
        # fall off bottom
      elsif $grid[y+1][x] == '.'
        $grid[y+1][x] = '|'
        $wa << [x, y+1]
        $water += 1
      elsif $grid[y+1][x] == '#' || $grid[y+1][x] == '~'
        if $grid[y][x-1] == '.'
          $grid[y][x-1] = '|'
          $wa << [x-1, y]
          $water += 1
        end

        if $grid[y][x+1] == '.'
          $grid[y][x+1] = '|'
          $wa << [x+1, y]
          $water += 1
        end

        if $grid[y][x+1] == '#'
          stuck = $grid[y].join =~ /#\|+#/

          if stuck
            (stuck + 1).upto(stuck + $&.length - 2) do |sx|
              #$wa.delete([sx,y])
              $grid[y][sx] = '~'
            end
          end
        end
      end
    end
  end
end

def print_grid
  0.upto($max_y) do |y|
    447.upto($max_x) do |x|
      print $grid.dig(y, x) || '.'
    end

    puts
  end
  puts
end

test_cases = [
['x=495, y=2..7
y=7, x=495..501
x=501, y=3..7
x=498, y=2..4
x=506, y=1..2
x=498, y=10..13
x=504, y=10..13
y=13, x=498..504',57]
]

test_cases.each_with_index do |(input, output), index|
  #raise "Test case #{index + 1} failed!" if run(input) != output
end

input = File.read("#{File.dirname($0)}/input/#{File.basename($0)[/\d+/]}.txt").chomp
puts run(input)
