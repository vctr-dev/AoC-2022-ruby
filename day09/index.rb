require "set"
def parse(file)
  File
    .read(file)
    .split("\n")
    .map { |v| [v.split(" ").first, v.split(" ").last.to_i] }
end

# old pos U/D/L/R -> tail go in that direction
# old pos diagonal -> tail goes diagonal
class Rope
  attr_accessor :head, :tail, :trail
  def initialize
    @head = [0, 0]
    @tail = [0, 0]
    @trail = Set[[0, 0]]
    @rel = { "above" => "U", "below" => "D", "left" => "L", "right" => "R" }
  end

  def get_rel()
    rel = []
    rel << @rel["left"] if @head.first < @tail.first
    rel << @rel["right"] if @head.first > @tail.first
    rel << @rel["above"] if @head.last < @tail.last
    rel << @rel["below"] if @head.last > @tail.last
    rel
  end

  def touching?(p1, p2)
    (p1.first - p2.first).abs < 2 && (p1.last - p2.last).abs < 2
  end

  def move_tail(d, rel)
    return if rel.empty?
    return if touching?(@head, @tail)
    return move!(@tail, d) if rel.length == 1
    return rel.each { |dir| move!(@tail, dir) }
  end

  def move!(point, d)
    point[1] -= 1 if d == "U"
    point[1] += 1 if d == "D"
    point[0] -= 1 if d == "L"
    point[0] += 1 if d == "R"
  end

  def move_head(d)
    rel = get_rel
    move!(@head, d)
    move_tail(d, rel)
    @trail << @tail[0..-1]
  end

  def moves(d, n)
    n.times { |_| move_head(d) }
  end
end

def part1(input)
  rope = Rope.new
  input.each { |(d, n)| rope.moves(d, n) }
  rope.trail.length
end

def part2(input)
  input
end

puts "Part 1"
p part1(parse("data.txt")) if part1(parse("sample.txt")) == 13

puts
puts "Part 2"
# p part2(parse("sample.txt"))
# p part2(parse("data.txt"))
