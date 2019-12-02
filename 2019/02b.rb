require_relative 'scaffold'

class Day2b < Scaffold
  def run
    cells = input.split(',').map(&:to_i)

    0.upto(99) do |noun|
      0.upto(99) do |verb|
        if !@testing
          cells[1] = noun
          cells[2] = verb
        end

        r = execute(cells.dup)
        return 100 * noun + verb if r == 19690720
      end
    end

    cells[0]
  end

  OPS = { 1 => :+, 2 => :* }

  def execute(cells, position = 0)
    opcode, in1, in2, out = cells[position, 4]

    if opcode == 99
      return cells[0]
    end

    v1 = cells[in1]
    v2 = cells[in2]
    r = v1.send(OPS[opcode], v2)
    cells[out] = r

    execute(cells, position + 4)
  end
end
