class Point
  getter :x, :y, :z, :i
  property :left, :right

  @left : Point?
  @right : Point?

  def initialize(x : Int64, y : Int64, z : Int64, i : Int64)
    @x = x
    @y = y
    @z = z
    @i = i
    @left = nil
    @right = nil
  end

  def -(other : Point) : Int64
    (x - other.x) ** 2 + (y - other.y) ** 2 + (z - other.z) ** 2
  end


end

i = 0
points = File.read("input.txt").chomp.split("\n").
  map { |s| s.split(",").map(&.to_i64) }.map { |a| Point.new(a[0], a[1], a[2], i += 1) }

distances = {} of Tuple(Point, Point) => Int64

points.each do |from|
  points.each do |to|
    next if from == to

    distance = from - to
    tuple = from.i < to.i ? {from, to} : {to, from}
    distances[tuple] = distance
  end
end

connections = [] of Array(Point)

distances.to_a.sort_by { |k, v| v }[0...1000].to_h.each do |k, v|
  foundLeft = nil
  foundRight = nil

  connections.each_with_index do |connection, i|
    if connection.includes?(k[0])
      connection << k[1] unless connection.includes?(k[1])
      foundLeft = i
    elsif connection.includes?(k[1])
      connection << k[0] unless connection.includes?(k[0])
      foundRight = i
    end
  end

  if !foundLeft && !foundRight
    connections << k.to_a
  elsif foundLeft && foundRight
    connections[foundLeft] = connections[foundLeft].concat(connections[foundRight]).uniq
    connections[foundRight] = [] of Point
  end
end

# 11616  - Low
# 123420 - ??
# 243936 - High

puts connections.sort_by { |c| -c.size }[0...3].product { |c| c.size }
