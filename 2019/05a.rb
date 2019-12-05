require_relative 'scaffold'

class Day5a < Scaffold
  OPS = {
    1 => -> (a,b,c) { $cells[c] = a + b },
    2 => -> (a,b,c) { $cells[c] = a * b },
    3 => -> (a) { $cells[a] = 1 },
    4 => -> (a) { puts $cells[a] },
  }

  def run
    $cells = input.split(',').map(&:to_i)
    position = 0

    loop do
      op1, op2, *modes = $cells[position].digits
      opcode = (op2||0)*10+op1

      exit if opcode == 99

      func = OPS[opcode]
      numparams = func.parameters.length

      (0...numparams).each { |n| modes[n] ||= 0 }
      modes[-1] = 1

      args = $cells[position+1, numparams].zip(modes).map { |x,mode| mode == 1 ? x : $cells[x] }

      func[*args]

      position += numparams + 1
    end
  end
end
