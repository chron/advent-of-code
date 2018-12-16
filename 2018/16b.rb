def run(input)
  lines = input.split(?\n)[0..3129]

  opcodes = [
    -> (a,b,c) { $r[c] = $r[a] + $r[b] },
    -> (a,b,c) { $r[c] = $r[a] + b },
    -> (a,b,c) { $r[c] = $r[a] * $r[b] },
    -> (a,b,c) { $r[c] = $r[a] * b },
    -> (a,b,c) { $r[c] = $r[a] & $r[b] },
    -> (a,b,c) { $r[c] = $r[a] & b },
    -> (a,b,c) { $r[c] = $r[a] | $r[b] },
    -> (a,b,c) { $r[c] = $r[a] | b },
    -> (a,b,c) { $r[c] = $r[a] },
    -> (a,b,c) { $r[c] = a },
    -> (a,b,c) { $r[c] = a > $r[b] ? 1 : 0 },
    -> (a,b,c) { $r[c] = $r[a] > b ? 1 : 0 },
    -> (a,b,c) { $r[c] = $r[a] > $r[b] ? 1 : 0 },
    -> (a,b,c) { $r[c] = a == $r[b] ? 1 : 0 },
    -> (a,b,c) { $r[c] = $r[a] == b ? 1 : 0 },
    -> (a,b,c) { $r[c] = $r[a] == $r[b] ? 1 : 0 }
  ]

  possibilities = Hash.new { |h,k| h[k] = [] }

  lines.each_slice(4) do |before,instr,after,_|
    next if before == ''

    registers_before = before.scan(/\d+/).map(&:to_i)
    registers_after = after.scan(/\d+/).map(&:to_i)
    op, *args = instr.scan(/\d+/).map(&:to_i)

    matching = opcodes.select do |o|
      $r = registers_before.dup
      o.call(*args)
      $r == registers_after
    end

    possibilities[op] |= matching
  end

  rules = {}

  until rules.size == 16
    known = possibilities.select { |k,v| v.count == 1 }

    known.each do |num,pr|
      rules[num] = pr.first
      possibilities.delete(num)
      possibilities.each { |k,v| v.delete(*pr) }
    end
  end

  $r = [0]*16
  program = input.split(?\n)[3129..-1]

  program.each do |line|
    op, *args = line.scan(/\d+/).map(&:to_i)
    next if !op
    rules[op].call(*args)
  end

  $r[0]
end

input = File.read("#{File.dirname($0)}/input/#{File.basename($0)[/\d+/]}.txt").chomp
puts run(input)
