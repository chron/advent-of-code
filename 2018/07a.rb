def run(input)
  steps = input.split("\n").map { |l| l.scan(/\b[A-Z]\b/) }
  deps = Hash.new { |h,k| h[k] = [] }
  steps.each { |a,b| deps[b] << a }
  steps_left = (deps.keys + deps.values).flatten.uniq.sort

  completed_steps = []

  until steps_left.empty?
    next_step = steps_left.find { |s| deps[s].all? { |dep| completed_steps.include?(dep) }}
    steps_left.delete(next_step)
    completed_steps << next_step
  end

  completed_steps * ''
end

test_cases = [
  ['Step C must be finished before step A can begin.
    Step C must be finished before step F can begin.
    Step A must be finished before step B can begin.
    Step A must be finished before step D can begin.
    Step B must be finished before step E can begin.
    Step D must be finished before step E can begin.
    Step F must be finished before step E can begin.', 'CABDFE']
]

test_cases.each_with_index do |(input, output), index|
  raise "Test case #{index + 1} failed!" if run(input) != output
end

input = File.read("#{File.dirname($0)}/input/#{File.basename($0)[/\d+/]}.txt").chomp
puts run(input)
