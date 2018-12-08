class Node < Struct.new(:children, :metadata)
  def value
    if children.empty?
      metadata.sum
    else
      metadata.map do |md|
        if md > 0
          children[md - 1]&.value || 0
        else
          0
        end
      end.sum
    end
  end
end

def run(input)
  $numbers = input.split.map(&:to_i)

  read_node.value
end

def read_node
  num_children = $numbers.shift
  num_meta = $numbers.shift

  n = Node.new
  n.children = (0...num_children).map { read_node }
  n.metadata = $numbers.shift(num_meta)
  n
end

test_cases = [
  ['2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2', 66]
]

test_cases.each_with_index do |(input, output), index|
  raise "Test case #{index + 1} failed!" if run(input) != output
end

input = File.read("#{File.dirname($0)}/input/#{File.basename($0)[/\d+/]}.txt").chomp
puts run(input)
