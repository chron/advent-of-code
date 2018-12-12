def run(input)
  lines = input.split(?\n)
  initial_state = lines.shift.gsub(/^.+ /, '')
  lines.shift # blank

  pots = ('.'*100 + initial_state + '.'*100).split('')
  rules = lines.map { |l| l.chomp.split(' => ') }

  0.upto(19) do |gen|
    next_pots = []
    # puts "#{gen.to_s.rjust(2, '0')} #{pots.join}"

    pots.each_with_index do |char,index|
      t = pots[index-2, 5].join

      match = rules.find { |pattern, outcome| pattern.strip == t }
      next_pots[index] = match&.last || ?.
    end

    pots = next_pots.dup
  end

  # puts "20 #{pots.join}"

  total = 0

  pots.each_with_index do |pot, index|
    total += (index-100) if pot == '#'
  end

  total
end

test_cases = [
  ['Initial state: #..#.#..##......###...###

  ...## => #
  ..#.. => #
  .#... => #
  .#.#. => #
  .#.## => #
  .##.. => #
  .#### => #
  #.#.# => #
  #.### => #
  ##.#. => #
  ##.## => #
  ###.. => #
  ###.# => #
  ####. => #', 325]
]

test_cases.each_with_index do |(input, output), index|
  raise "Test case #{index + 1} failed!" if run(input) != output
end

input = File.read("#{File.dirname($0)}/input/#{File.basename($0)[/\d+/]}.txt").chomp
puts run(input)
