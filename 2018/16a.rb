def run(input)
  lines = input.split(?\n)[0..3129]

  candidates = 0

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

  lines.each_slice(4) do |before,instr,after,_|
    next if before == ''

    registers_before = before.scan(/\d+/).map(&:to_i)
    registers_after = after.scan(/\d+/).map(&:to_i)
    op, *args = instr.scan(/\d+/).map(&:to_i)

    matching = opcodes.count do |o|
      $r = registers_before.dup
      o.call(*args)
      $r == registers_after
    end

    candidates += 1 if matching >= 3
  end

  candidates
end

input = File.read("#{File.dirname($0)}/input/#{File.basename($0)[/\d+/]}.txt").chomp
puts run(input)
