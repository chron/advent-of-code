def run(input)
  $r = [1, 0, 0, 0, 0, 0]
  lines = input.split(?\n)[1..-1].map { |l| [*l.scan(/^#?(\w+)/).first, *l.scan(/\d+/).map(&:to_i)] }
  $ipr = input.scan(/ip (\d+)/).first.first.to_i
  $ip = 0

  instructions = {
    ip: -> (a) { $ipr = a },
    addr: -> (a,b,c) { $r[c] = $r[a] + $r[b] },
    addi: -> (a,b,c) { $r[c] = $r[a] + b },
    mulr: -> (a,b,c) { $r[c] = $r[a] * $r[b] },
    muli: -> (a,b,c) { $r[c] = $r[a] * b },
    banr: -> (a,b,c) { $r[c] = $r[a] & $r[b] },
    bani: -> (a,b,c) { $r[c] = $r[a] & b },
    borr: -> (a,b,c) { $r[c] = $r[a] | $r[b] },
    bori: -> (a,b,c) { $r[c] = $r[a] | b },
    setr: -> (a,b,c) { $r[c] = $r[a] },
    seti: -> (a,b,c) { $r[c] = a },
    gtir: -> (a,b,c) { $r[c] = a > $r[b] ? 1 : 0 },
    gtri: -> (a,b,c) { $r[c] = $r[a] > b ? 1 : 0 },
    gtrr: -> (a,b,c) { $r[c] = $r[a] > $r[b] ? 1 : 0 },
    eqir: -> (a,b,c) { $r[c] = a == $r[b] ? 1 : 0 },
    eqri: -> (a,b,c) { $r[c] = $r[a] == b ? 1 : 0 },
    eqrr: -> (a,b,c) { $r[c] = $r[a] == $r[b] ? 1 : 0 }
  }

  loop {
    if $ip == 1
      return (1..($r[2]+1)).select { |v| $r[2]%v == 0 }.sum
    end

    opcode, *args = lines[$ip]

    $r[$ipr] = $ip

    instructions[opcode.to_sym].call(*args)

    $ip = $r[$ipr]
    $ip += 1

    break if $ip < 0 || $ip >= lines.size
  }
end

input = File.read("#{File.dirname($0)}/input/#{File.basename($0)[/\d+/]}.txt").chomp
puts run(input)
