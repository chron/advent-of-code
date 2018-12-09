def run(input)
  players, last_marble = input.scan(/\d+/).map(&:to_i)
  scores = Hash.new(0)
  circle = [0]
  next_marble = 1
  current_index = 0

  (0...players).cycle do |player|
    active_marble = next_marble
    break if active_marble > last_marble
    next_marble += 1

    if active_marble % 23 == 0 && active_marble > 0
      second_to_remove = circle[current_index - 7]
      current_index = circle.index(second_to_remove)
      circle.delete(second_to_remove)

      scores[player] += active_marble + second_to_remove
    else
      circle[(current_index+1) % circle.length + 1, 0] = active_marble
      current_index = circle.index(active_marble)
    end

    #p [current_index, circle.join(' ')]
  end

  #p scores
  #p scores.values.max
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

input = File.read("#{File.dirname($0)}/input/#{File.basename($0)[/\d+/]}.txt").chomp
puts run(input)
