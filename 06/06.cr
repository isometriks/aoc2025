raw_input = File.read("input.txt").chomp.split("\n")
input = raw_input.map { |s| s.strip.split(/\s+/) }
operators = input.pop
rows = input.map { |r| r.map(&.to_i64) }
columns = rows.transpose

part1 = columns.map_with_index do |column, i|
  if operators[i] == "*"
    column.product
  else
    column.sum
  end
end.sum

puts "Part 1: #{part1}"

indices = raw_input.last.scan(/[\*|\+]/).map { |m| m.begin }

part2 = raw_input[...-1].map do |row|
  (0...indices.size).map do |i|
    i == indices.size - 1 ? row[indices[i]..] : row[indices[i]...indices[i + 1] - 1]
  end
end.transpose.map do |numbers|
  max_size = numbers.max_by { |n| n.size }.size
  (1..max_size).map do |i|
    numbers.map do |number|
      number[max_size - i]
    end
  end.map do |strings|
    n = strings.join("").strip
    n == "" ? 0.to_i64 : n.to_i64
  end
end.map_with_index do |column, i|
  if operators[i] == "*"
    column.product
  else
    column.sum
  end
end.sum

puts "Part 2: #{part2}"
