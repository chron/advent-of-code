require_relative 'scaffold'

class Day3a < Scaffold
  #test_case "R8,U5,L5,D3\nU7,R6,D4,L4", 6

  C = 11000
  M = 22000
  def set_cell(x, y, wirenum)
    raise [x,y].inspect if @grid[y].nil?

    if @grid[y][x] == '.'
      @grid[y][x] = wirenum.to_s
    elsif @grid[y][x] == wirenum.to_s
      #no
    else
      @cols << [x,y]
      puts "Col: #{(x - C).abs + (y - C).abs}"
      @grid[y][x] = '!'
    end
  end

  def find_closest(char='!', x=C, y=C)
    dists = @cols.map { |ox,oy| (ox-x).abs + (oy-y).abs } - [0]
    dists.min
  end

  def run
    @cols = []
    @grid = Array.new(M) { Array.new(M, '.') }

    wires = input.split("\n")

    wires.each_with_index do |wire, wirenum|
      x,y = C,C

      wire.split(',').each do |s|
        #print ?.
        dir, dist = s.scan(/(.)(.+)/).first
        dist = dist.to_i

        raise [x,y,'oob'].inspect if x < 0 || y < 0
        #p [x, y, dir, dist, wirenum]

        if dir == ?U
          y.upto(y + dist) { |ny| set_cell(x, ny, wirenum) }
          y = y + dist
        elsif dir == ?D
          y.downto(y - dist) { |ny| set_cell(x, ny, wirenum) }
          y = y - dist
        elsif dir == ?R
          x.upto(x + dist) { |nx| set_cell(nx, y, wirenum) }
          x = x + dist
        elsif dir == ?L
          x.downto(x - dist) { |nx| set_cell(nx, y, wirenum) }
          x = x - dist
        else
          raise 'wat'
        end
      end
    end

    # p @cols
    # puts @grid[1000..1020].map { |row| row[1000..1020].join }

    find_closest
  end
end
