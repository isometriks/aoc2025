class Bank
  getter :batteries

  def initialize(batteries : Array(Int32))
    @batteries = batteries
  end

  def largest_from_sequence(sequence = batteries) : Tuple(Int32, Int32)
    max = 0
    max_position = 0

    sequence.each_with_index do |value, index|
      if max.nil? || value > max
        max = value
        max_position = index
      end
    end

    {max, max_position}
  end

  def largest_sequence(n : Int32)
    output = [] of Int32
    root_position = 0

    (0..(n-1)).to_a.reverse.each do |offset|
      range = offset.zero? ? batteries[root_position...] : batteries[root_position...-offset]
      max, position = largest_from_sequence(range)
      root_position += position + 1

      output << max
    end

    output
  end
end

banks = File.read("input.txt").chomp.split("\n")
  .map { |s| Bank.new(s.split("").map(&.to_i)) }

part1 = banks.sum do |bank|
  bank.largest_sequence(2).map(&.to_s).join.to_i
end

part2 = banks.sum do |bank|
  bank.largest_sequence(12).map(&.to_s).join.to_i64
end

puts "Part 1: #{part1}"
puts "Part 2: #{part2}"
