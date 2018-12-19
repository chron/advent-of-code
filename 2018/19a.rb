def run(input)
  $r = [0] * 6
  lines = input.split(?\n)[1..-1].map { |l| [*l.scan(/^#?(\w+)/).first, *l.scan(/\d+/).map(&:to_i)] }
  $ip = 0
  $ipr = input.scan(/ip (\d+)/).first.first.to_i

  instructions = {
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
    opcode, *args = lines[$ip]

    $r[$ipr] = $ip
    #print "#{$ip} #{$r.inspect} #{opcode} #{args.join(' ')}"
    instructions[opcode.to_sym].call(*args)
    #p $r
    $ip = $r[$ipr]
    $ip += 1

    break if $ip < 0 || $ip >= lines.size
  }

  $r[0]
end

test_cases = [
['#ip 0
seti 5 0 1
seti 6 0 2
addi 0 1 0
addr 1 2 3
setr 1 0 0
seti 8 0 4
seti 9 0 5', 6]
]

test_cases.each_with_index do |(input, output), index|
 # raise "Test case #{index + 1} failed!" if run(input) != output
end

input = File.read("#{File.dirname($0)}/input/#{File.basename($0)[/\d+/]}.txt").chomp
puts run(input)
