require_relative 'scaffold'

class Day2a < Scaffold
  test_case '1,0,0,0,99', '2'
  test_case '2,3,0,3,99', '2'
  test_case '2,4,4,5,99,0', '2'

  def run
    cells = input.split(',').map(&:to_i)

    if !@testing
      cells[1] = 12
      cells[2] = 2
    end

    execute(cells)

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
