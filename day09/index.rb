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
  attr_accessor :head, :tail, :trail, :trailing

  def initialize(num_tails)
    @head = [0, 0]
    @trailing = num_tails > 0 && Rope.new(num_tails - 1)
    @trail = Set[[0, 0]]
    @rel = { "above" => "U", "below" => "D", "left" => "L", "right" => "R" }
  end

  def get_rel
    rel = []
    tail = @trailing.head
    rel << @rel["left"] if @head.first < tail.first
    rel << @rel["right"] if @head.first > tail.first
    rel << @rel["above"] if @head.last < tail.last
    rel << @rel["below"] if @head.last > tail.last
    rel
  end

  def touching?(p1, p2)
    (p1.first - p2.first).abs < 2 && (p1.last - p2.last).abs < 2
  end

  def move!(point, d)
    point[1] -= 1 if d == "U"
    point[1] += 1 if d == "D"
    point[0] -= 1 if d == "L"
    point[0] += 1 if d == "R"
  end

  def moves(d, n)
    n.times do |_|
      moves_head([d])
      commit
    end
  end

  def moves_head(dirs)
    dirs.each { |d| move!(@head, d) }
    move_rest if @trailing
  end

  def move_rest
    return if touching?(@head, @trailing.head)
    # depends on new relative position. if new relative position is right/left/top/bottom, then only move in that direction, else move diagonal
    return @trailing.moves_head(get_rel)
  end

  def get_tail
    tail = self.trailing
    tail = tail.trailing while tail.trailing
    tail
  end

  def commit
    return @trailing.commit if @trailing
    @trail << @head[0..-1]
  end
end

def viz(graph)
  graph = graph.to_a
  x_minmax = graph.map { |(x)| x }.minmax
  y_minmax = graph.map { |(_, y)| y }.minmax
  output = ""
  (y_minmax[0]..y_minmax[1]).each do |y|
    collect = ""
    (x_minmax[0]..x_minmax[1]).each do |x|
      collect += graph.include?([x, y]) ? "#" : "."
    end
    puts collect
  end
end

def part1(input)
  rope = Rope.new(1)
  input.each { |(d, n)| rope.moves(d, n) }
  viz(rope.get_tail.trail)
  rope.get_tail.trail.length
end

def part2(input)
  rope = Rope.new(9)
  input.each { |(d, n)| rope.moves(d, n) }
  viz(rope.get_tail.trail)
  rope.get_tail.trail.length
end

puts "Part 1"
p part1(parse("sample.txt"))
p part1(parse("data.txt"))

puts
puts "Part 2"
p part2(parse("sample.txt"))
p part2(parse("sample2.txt"))
p part2(parse("data.txt"))
