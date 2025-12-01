class Dial
  getter :history

  @history = [] of NamedTuple(from: Int32, to: Int32, full_turns: Int32, amount: Int32)
  @position : Int32

  def initialize(position : Int32 = 0)
    @position = position
    @history << {
      from: @position,
      to: @position,
      full_turns: 0,
      amount: 0,
    }
  end

  def turn(direction : String, amount : Int32)
    full_turns = amount // 100
    amount -= 100 * full_turns
    amount *= -1 if direction == "L"

    turn_by(amount, full_turns)
  end

  private def turn_by(amount : Int32, full_turns : Int32)
    from = @position
    @position += amount
    @position = @position % 100

    @history << {
      from: from,
      to: @position,
      full_turns: full_turns,
      amount: amount,
    }
  end
end

dial = Dial.new(50)

File.open("input.txt").each_line do |line|
  matches = line.match(/(L|R)(\d+)/)

  next unless matches

  dial.turn(matches[1], matches[2].to_i)
end

part1 = dial.history.select { |p| p[:to] == 0 }.size

puts "Part 1: #{part1}"

part2 = dial.history.map do |p|
  total = p[:full_turns]
  absolute = p[:from] + p[:amount]

  if (absolute >= 100 || absolute < 0 || p[:to] == 0) && p[:from] != 0
    total += 1
  end

  total
end.sum

puts "Part 2: #{part2}"

