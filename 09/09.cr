points = File.read("input.txt").chomp.split("\n").
  map { |s| s.split(",").map(&.to_i64) }

largest = 0
points.each do |p1|
  points.each do |p2|
    next if p1 == p2

    area = ((p1[0] - p2[0] + 1) * (p1[1] - p2[1] + 1)).abs
    largest = [largest, area].max
  end
end

puts "Part 1: #{largest}"
