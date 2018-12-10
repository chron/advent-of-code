def run(input)
  nodes = input.split("\n").map { |l| l.scan(/-?\d+/).map(&:to_i) }

  1.upto(50000) do |tick|
    nodes.map! { |x,y,dx,dy| [x+dx,y+dy,dx,dy] }

    min_x, max_x = nodes.map { |n| n[0] }.minmax
    min_y, max_y = nodes.map { |n| n[1] }.minmax

    if max_y - min_y < 50
      p tick # for part b

      h = {}

      nodes.each { |x,y,_,_| h[[x,y]] = 1 }

      min_y.upto(max_y) do |y|
        min_x.upto(max_x) do |x|
          print h[[x,y]] ? "#" : " "
        end

        puts
      end
    end
  end
end

input = File.read("#{File.dirname($0)}/input/#{File.basename($0)[/\d+/]}.txt").chomp
puts run(input)
