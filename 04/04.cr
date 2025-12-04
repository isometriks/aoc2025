class Map
  getter :rows

  def initialize(rows : Array(Array(String)))
    @rows = rows
    @copy = rows.clone
  end

  def iterate
    (0...rows.size).each do |y|
      (0...rows[y].size).each do |x|
        yield x, y
      end
    end
  end

  def debug
    rows.each do |row|
      puts row.join("")
    end
  end

  def char_at(x, y)
    return if y < 0 || y >= rows.size
    return if x < 0 || x >= rows[y].size

    rows[y][x]
  end

  def adjacent(x, y, char)
    (-1..1).map do |dx|
      (-1..1).map do |dy|
        if dx == 0 && dy == 0
          false
        else
          char_at(x + dx, y + dy) == char
        end
      end
    end.flatten.select { |v| v }.size
  end

  def alter_copy(x, y, char)
    @copy[y][x] = char
  end

  def pop_copy
    @rows = @copy
    @copy = @rows.clone
  end

  def find_and_remove_from_copy
    count = 0

    iterate do |x, y|
      next unless char_at(x, y) == "@"

      if adjacent(x, y, "@") < 4
        count += 1
        alter_copy(x, y, ".")
      end
    end

    count
  end
end

rows = File.read("input.txt").chomp.split("\n")
  .map { |s| s.split("") }

map = Map.new(rows)
total = map.find_and_remove_from_copy

puts "Part 1: #{total}"

loop do
  map.pop_copy
  removed = map.find_and_remove_from_copy
  total += removed

  break if removed == 0
end

puts "Part 2: #{total}"
map.debug
