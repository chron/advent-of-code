def run(input)
  lines = input.split(?\n)
  initial_state = lines.shift.gsub(/^.+ /, '')
  lines.shift # blank

  buffer = 10000
  pots = ('.'*buffer + initial_state + '.'*buffer).split('')
  rules = lines.map { |l| l.chomp.split(' => ') }
  last_total = last_diff = 0

  1.upto(200) do |gen|
    next_pots = []

    pots.each_with_index do |char,index|
      t = pots[index-2, 5].join

      match = rules.find { |pattern, outcome| pattern.strip == t }
      next_pots[index] = match&.last || ?.
    end

    pots = next_pots.dup
    total = 0

    pots.each_with_index do |pot, index|
      total += (index-buffer) if pot == '#'
    end

    # p [gen, total, total - last_total]

    last_diff = total - last_total
    last_total = total
  end

  (50_000_000_000 - 200) * last_diff + last_total
end

input = File.read("#{File.dirname($0)}/input/#{File.basename($0)[/\d+/]}.txt").chomp
puts run(input)
