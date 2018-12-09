Marble = Struct.new(:value, :prev, :next)

def run(input)
  players, last_marble = input.scan(/\d+/).map(&:to_i)
  last_marble *= 100 if $go
  scores = Hash.new(0)
  next_marble = 1
  current_marble = Marble.new(0)
  current_marble.next = current_marble
  current_marble.prev = current_marble

  (0...players).cycle do |player|
    break if next_marble > last_marble

    m = Marble.new(next_marble)

    if next_marble % 23 == 0 && next_marble > 0
      to_remove = current_marble
      7.times { to_remove = to_remove.prev }

      before = to_remove.prev
      after = to_remove.next

      before.next = after
      after.prev = before
      current_marble = after

      scores[player] += next_marble + to_remove.value
    else
      before = current_marble.next
      after = before.next
      before.next = m
      after.prev = m
      m.prev = before
      m.next = after
      current_marble = m
    end

    next_marble += 1
  end

  scores.values.max
end

test_cases = [
  ['9 25', 32],
  ['10 players; last marble is worth 1618 points', 8317],
  ['13 players; last marble is worth 7999 points', 146373],
  ['17 players; last marble is worth 1104 points', 2764],
  ['21 players; last marble is worth 6111 points', 54718],
  ['30 players; last marble is worth 5807 points', 37305]
]

test_cases.each_with_index do |(input, output), index|
  raise "Test case #{index + 1} failed!" if run(input) != output
end

$go = true
input = File.read("#{File.dirname($0)}/input/#{File.basename($0)[/\d+/]}.txt").chomp
puts run(input)
