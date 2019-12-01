def run(input)
  input
    .split
    .map(&:to_i)
    .map { |i| calc_module(i) }
    .sum
end

def calc_module(i, t=0)
  r = (i / 3).floor - 2

  r > 0 ? calc_module(r, r+t) : t
end

test_cases = [
  ['14', '2'],
  ['1969', '966'],
  ['100756', '50346'],
]

test_cases.each_with_index do |(input, expected), index|
  actual = run(input)

  raise "Test case #{index + 1} failed! #{actual}" if actual.to_s != expected.to_s
end

input = File.read("#{File.dirname($0)}/input/#{File.basename($0)[/\d+/]}.txt").chomp
puts run(input)
