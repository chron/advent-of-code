def run(input)
  iterations = input.to_i
  elves = [0, 1]
  recipes = [3, 7]

  until recipes.length >= iterations + 10
    new_recipe = 0

    elves.each do |c|
      new_recipe += recipes[c]
    end

    recipes.push *new_recipe.digits.reverse

    elves.map! do |c|
      (c + recipes[c] + 1) % recipes.length
    end
  end

  recipes[iterations, 10]*''
end

test_cases = [
  ['9', '5158916779'],
  ['5', '0124515891'],
  ['18', '9251071085'],
  ['2018', '5941429882']
]

test_cases.each_with_index do |(input, output), index|
  r = run(input)
  raise "Test case #{index + 1} failed with #{r}" if r != output
end

input = File.read("#{File.dirname($0)}/input/#{File.basename($0)[/\d+/]}.txt").chomp
puts run(input)
