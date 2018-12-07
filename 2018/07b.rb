def run(input)
  steps = input.split("\n").map { |l| l.scan(/\b[A-Z]\b/) }
  deps = Hash.new { |h,k| h[k] = [] }
  steps.each { |a,b| deps[b] << a }
  steps_left = (deps.keys + deps.values).flatten.uniq.sort
  total_steps = steps_left.length

  completed_steps = []

  time_spent_on_step = Hash.new(0)

  total_time_spent = 0
  workers = Array.new($workers)

  until completed_steps.length == total_steps
    workable_steps = steps_left.select { |s| deps[s].all? { |dep| completed_steps.include?(dep) }}

    workers.map! do |current_task|
      if current_task.nil?
        next_task = workable_steps.shift
        steps_left.delete(next_task)
      else
        next_task = current_task
      end

      if next_task
        time_spent_on_step[next_task] += 1

        if time_spent_on_step[next_task] >= ($penalty + next_task.ord - 64)
          completed_steps << next_task
          next_task = nil
        end
      end

      next_task
    end

    total_time_spent += 1
  end

  total_time_spent
end

$workers = 2
$penalty = 0

test_cases = [
  ['Step C must be finished before step A can begin.
    Step C must be finished before step F can begin.
    Step A must be finished before step B can begin.
    Step A must be finished before step D can begin.
    Step B must be finished before step E can begin.
    Step D must be finished before step E can begin.
    Step F must be finished before step E can begin.', 15]
]

test_cases.each_with_index do |(input, output), index|
  raise "Test case #{index + 1} failed!" if run(input) != output
end

$workers = 5
$penalty = 60

input = File.read("#{File.dirname($0)}/input/#{File.basename($0)[/\d+/]}.txt").chomp
puts run(input)
