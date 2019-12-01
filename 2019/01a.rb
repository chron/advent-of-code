def run(input)
  input
    .split
    .map(&:to_i)
    .map { |i| (i / 3).floor - 2 }
    .sum
end

test_cases = [
  ['12', '2'],
  ['14', '2'],
  ['1969', '654'],
  ['100756', '33583'],
]

test_cases.each_with_index do |(input, expected), index|
  actual = run(input)

  raise "Test case #{index + 1} failed! #{actual}" if actual.to_s != expected.to_s
end

input = File.read("#{File.dirname($0)}/input/#{File.basename($0)[/\d+/]}.txt").chomp
puts run(input)
