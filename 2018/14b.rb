def run(input)
  target = input.split('').map(&:to_i)
  elves = [0, 1]
  recipes = [3, 7]

  match_pos = nil
  done = 0

  check = -> do
    if recipes.last == target[done]
      done += 1
      match_pos ||= recipes.length - 1
    elsif recipes.last == target[0]
      done = 1
      match_pos = recipes.length - 1
    else
      match_pos, done = nil, 0
    end

    if done == target.length
      true
    end
  end

  loop do
    new_recipe = 0

    elves.each do |c|
      new_recipe += recipes[c]
    end

    if new_recipe >= 10
      recipes << new_recipe / 10
      return match_pos if check.call
    end
    recipes << new_recipe % 10
    return match_pos if check.call

    elves.map! do |c|
      (c + recipes[c] + 1) % recipes.length
    end
  end
end

test_cases = [
  ['51589', 9],
  ['01245', 5],
  ['92510', 18],
  ['59414', 2018]
]

test_cases.each_with_index do |(input, output), index|
  r = run(input)
  raise "Test case #{index + 1} failed with #{r}" if r != output
end

input = File.read("#{File.dirname($0)}/input/#{File.basename($0)[/\d+/]}.txt").chomp
puts run(input)
