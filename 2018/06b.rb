def run(input)
  coords = input.split("\n").map { |l| l.split(',').map(&:to_i) }

  r = 0
  b = 1000
  coords_v = {}

  (-b).upto(b).each do |v|
    coords_v[v] = coords.map { |cx,cy| [cx, cy, (v - cx).abs, (v - cy).abs] }
  end

  (-b).upto(b) do |x|
    xv = coords_v[x].map { |n| n[2] }.sum

    if xv < $limit
      (-b).upto(b) do |y|
        r += 1 if xv + coords_v[y].map { |n| n[3] }.sum < $limit
      end
    end
  end

  r
end

$limit = 32

test_cases = [
  ['1, 1
    1, 6
    8, 3
    3, 4
    5, 5
    8, 9', 16]
]

test_cases.each_with_index do |(input, output), index|
  raise "Test case #{index + 1} failed!" if run(input) != output
end

$limit = 10000
input = File.read("#{File.dirname($0)}/input/#{File.basename($0)[/\d+/]}.txt").chomp
puts run(input)
