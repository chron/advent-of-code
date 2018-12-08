def run(input)
  $metadata = []
  $numbers = input.split.map(&:to_i)

  read_node

  $metadata.sum
end

def read_node
  num_children = $numbers.shift
  num_meta = $numbers.shift

  num_children.times { read_node }
  num_meta.times { $metadata << $numbers.shift }
end

test_cases = [
  ['2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2', 138]
]

test_cases.each_with_index do |(input, output), index|
  raise "Test case #{index + 1} failed!" if run(input) != output
end

input = File.read("#{File.dirname($0)}/input/#{File.basename($0)[/\d+/]}.txt").chomp
puts run(input)
