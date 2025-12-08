class Grid
  @start_x : Int32

  getter :start_x

  def initialize(grid = [] of Array(String))
    @grid = grid
    @start_x = grid.first.index { |c| c == "S" } || 0
  end

  def detect_splits(x : Int32, y : Int32)
    return 0 if x < 0 || x >= @grid.first.size

    (y...@grid.size).each do |y|
      case char_at(x, y)
      when "|"
        return 0
      when "^"
        return 1 + detect_splits(x - 1, y) + detect_splits(x + 1, y)
      else
        @grid[y][x] = "|"
      end
    end

    0
  end

  @cache = {} of String => Int64

  def memoized_splits(x : Int32, y : Int32)
    @cache["#{x}-#{y}"] ||= detect_all_splits(x, y)
  end

  def detect_all_splits(x : Int32, y : Int32)
    return 0.to_i64 if x < 0 || x >= @grid.first.size

    (y...@grid.size).each do |y|
      if char_at(x, y) == "^"
        return 1.to_i64 + memoized_splits(x - 1, y) + memoized_splits(x + 1, y)
      end
    end

    0.to_i64
  end

  def splits_from_start
    detect_splits(start_x, 0)
  end

  def all_splits_from_start
    1.to_i64 + detect_all_splits(start_x, 0)
  end

  def debug
    @grid.each { |l| puts l.join("") }
  end

  private def char_at(x : Int32, y : Int32)
    @grid[y][x]
  end
end

input = File.read("input.txt").chomp.split("\n").map { |l| l.split("") }
grid = Grid.new(input)

puts "Part 1: #{grid.splits_from_start}"
grid.debug

puts "Part 2: #{grid.all_splits_from_start}"
