def run(input)

end

test_cases = [

]

test_cases.each_with_index do |(input, output), index|
  raise "Test case #{index + 1} failed!" if run(input) != output
end

input = File.read("#{File.dirname($0)}/input/#{File.basename($0)[/\d+/]}.txt").chomp
puts run(input)
