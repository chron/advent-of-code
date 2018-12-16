Unit = Struct.new(:x, :y, :faction, :attack, :hp)
class ElfDiedError < StandardError; end

def manhattan(x1,y1,x2,y2)
  (x1 - x2).abs + (y1 - y2).abs
end

def dist(x1,y1,x2,y2)
  distances = Hash.new { |h,k| h[k] = {} }
  distances[y1][x1] = 0

  flood_fill_from(x1, y1, 0, distances)

  distances[y2][x2]
end

def best_path(x1,y1,x2,y2)
  distances = Hash.new { |h,k| h[k] = {} }
  distances[y2][x2] = 0

  flood_fill_from(x2, y2, 0, distances)

  options = [[x1+1,y1],[x1-1,y1],[x1,y1-1],[x1,y1+1]]
  options.select { |x,y| distances[y][x] }.min_by { |x,y| [distances[y][x], y, x] }
end

def flood_fill_from(x,y,v,distances)
  opts = [[x+1,y],[x-1,y],[x,y-1],[x,y+1]].reject do |nx,ny|
    (distances[ny][nx] && distances[ny][nx] <= v + 1) || $board[ny][nx] != '.'
  end

  opts.each { |nx,ny| distances[ny][nx] = v+1 }
  opts.each { |nx,ny| flood_fill_from(nx,ny,v+1,distances) }
end

def run(input)
  32.upto(100) do |trial_ap|
    begin
      rounds_completed = 0
      $units = []
      $board = Hash.new { |h,k| h[k] = {} }

      input.split(?\n).each_with_index do |l,y|
        char = l.split('').each_with_index do |c,x|
          if c == 'G' || c == 'E'
            $units << Unit.new(x,y,c,c == 'E' ? trial_ap : 3,200)
          end

          $board[y][x] = c
        end
      end

      loop do
        $units.sort_by { |u| [u.y,u.x] }.each do |u|
          next if u.hp <= 0

          targets = $units.select { |t| t.hp > 0 && t.faction != u.faction }

          if targets.empty?
            return rounds_completed * $units.select { |t| t.hp > 0 }.map(&:hp).sum
          end

          if attack_if_possible(u, targets)
            # yeah
          else
            adjacent = targets.flat_map { |t| [[t.x-1,t.y],[t.x+1,t.y],[t.x,t.y-1],[t.x,t.y+1]] }
            valid_adjacent = adjacent.select { |x,y| $board[y][x] == '.' }.map { |x,y| [x, y, dist(u.x, u.y, x, y)] }
            valid_adjacent.reject! { |x,y,dist| dist.nil? }

            if valid_adjacent.any?
              best_x, best_y = valid_adjacent.min_by { |x,y,d| [d, y, x] }

              next_x, next_y = best_path(u.x,u.y,best_x,best_y)

              if next_x && next_y
                $board[u.y][u.x] = '.'
                u.x = next_x
                u.y = next_y
                $board[u.y][u.x] = u.faction

                attack_if_possible(u, targets)
              end
            end
          end
        end

        rounds_completed += 1
        print ?.
        #print_board
      end
    rescue ElfDiedError
      puts "=> Elf died at #{trial_ap}"
    end
  end
end

def print_board
  $board.each do |i,row|
    print row.values.join
    puts ' %1s %3i' % [$units[i].faction, $units[i].hp] if $units[i]
  end

  puts
end

def attack_if_possible(u, targets)
  attackable = targets.select { |t| manhattan(u.x, u.y, t.x, t.y) == 1 }

  if attackable.any?
    t = attackable.min_by { |t| [t.hp, t.y, t.x] }
    t.hp -= u.attack

    if t.hp <= 0
      raise ElfDiedError if t.faction == 'E'
      $board[t.y][t.x] = '.'
    end

    true
  else
    false
  end
end

test_cases = [
['#######
#.G...#
#...EG#
#.#.#G#
#..G#E#
#.....#
#######',4988],
['#######
#E..EG#
#.#G.E#
#E.##E#
#G..#.#
#..E#.#
####### ',31284],
['#######
#E.G#.#
#.#G..#
#G.#.G#
#G..#.#
#...E.#
#######',3478],
['#######
#.E...#
#.#..G#
#.###.#
#E#G#G#
#...#G#
#######',6474],
['#########
#G......#
#.E.#...#
#..##..G#
#...##..#
#...#...#
#.G...G.#
#.....G.#
#########',1140]
]

test_cases.each_with_index do |(input, output), index|
  #raise "Test case #{index + 1} failed!" if run(input) != output
end

input = File.read("#{File.dirname($0)}/input/#{File.basename($0)[/\d+/]}.txt").chomp
puts run(input)
