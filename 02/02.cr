class SkuFinder
  getter :from, :to

  def initialize(from : Int64, to : Int64)
    @from = from
    @to = to
  end

  def invalid_skus(pair_length : Int32 = 2)
    to_length = to.to_s.size
    from_length = from.to_s.size
    start_from = from.to_s[0, (to_length / pair_length).ceil.to_i].to_i64

    invalid = [] of Int64

    loop do
      sku = ("#{start_from}" * pair_length).to_i64

      if sku < from
        start_from += 1

        next
      end

      if sku > to
        break
      end

      invalid << sku

      start_from += 1
    end

    invalid
  end
end

pairs = File.read("input.txt").split(',').map { |s| s.split('-').map(&.to_i64) }

part1_invalid = [] of Int64
part2_invalid = [] of Int64

sku_finders = pairs.map do |pair|
  from = pair[0]
  to = pair[1]

  if to.to_s.size > from.to_s.size
    # takes 937-1112 and makes 937-999 and 1000-1112
    cutoff = "1#{"0" * from.to_s.size}".to_i64

    [
      SkuFinder.new(from, cutoff - 1),
      SkuFinder.new(cutoff, to),
    ]

  else
    SkuFinder.new(from, to)
  end
end.flatten

sku_finders.each do |sku_finder|
  part1_invalid += sku_finder.invalid_skus(2)

  to_length = sku_finder.to.to_s.size

  (2..to_length).each do |i|
    next if to_length / i != to_length // i

    part2_invalid += sku_finder.invalid_skus(i)
  end
end

puts "Part 1: #{part1_invalid.sum}"
puts "Part 2: #{part2_invalid.uniq.sum}"
