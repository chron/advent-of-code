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

  1.upto(300) do |window|
    1.upto(300-window+1) do |y|
      1.upto(300-window+1) do |x|
        v = 0

        0.upto(window-1) do |dx|
          0.upto(window-1) do |dy|
            v += grid[x+dx][y+dy]
          end
        end

        if v > largest
          largest = v
          lv = [x, y, window]
        end
      end
    end

    p [window, lv*',', largest]
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

test_cases = [
  ['18', '90,269,16'],
  ['42', '232,251,12']
]

test_cases.each_with_index do |(input, output), index|
  raise "Test case #{index + 1} failed!" if run(input) != output
end

input = File.read("#{File.dirname($0)}/input/#{File.basename($0)[/\d+/]}.txt").chomp
puts run(input)
