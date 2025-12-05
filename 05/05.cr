class FreshRange
  getter :first
  getter :last

  def initialize(first : Int64, last : Int64)
    @first = first
    @last = last
  end

  def contains?(ingredient)
    range.includes?(ingredient)
  end

  def range
    (@first..@last)
  end
end

ranges, ingredients = File.read("input.txt").chomp.split("\n\n").map { |s| s.split("\n") }
ranges = ranges.map { |s| s.split("-").map(&.to_i64) }.map { |p| FreshRange.new(p[0], p[1]) }
ingredients = ingredients.map(&.to_i64)

part1 = ingredients.select do |ingredient|
  ranges.any? { |r| r.contains?(ingredient) }
end.size

puts "Part 1: #{part1}"
combined_ranges = ranges

loop do
  sorted = combined_ranges.sort_by { |r| r.first }
  combined_ranges = [] of FreshRange
  i = 0

  loop do
    current = sorted[i]
    combine = [current] + sorted[(i+1)..].take_while { |r| r.first <= current.last }
    combined_ranges << FreshRange.new(combine.min_by { |c| c.first }.first, combine.max_by { |c| c.last }.last)
    i += combine.size

    break if i >= sorted.size
  end

  break if combined_ranges.size == sorted.size
end

puts "Part 2: #{combined_ranges.sum { |r| (r.last - r.first) + 1 }}"
