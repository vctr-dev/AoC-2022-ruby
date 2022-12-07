def parse(file)
  File
    .read(file)
    .split("\n")
    .map { |l| l.split(" ") }
    .map do |(f, s, *r)|
      if f == "$"
        C.new(s, r)
      else
        (f == "dir" ? D.new(s, nil) : F.new(s, f.to_i, nil))
      end
    end
end

class D
  attr_accessor :n, :c, :p

  def initialize(n, parent)
    @n = n
    @p = parent
    @c = []
  end

  def goto(path)
    return p if path == ".."
    return c.find { |d| d.is_a?(D) && d.n == path }
  end

  def add_child(c)
    @c << c
  end

  def to_s
    "#{@n} (directory)"
  end

  def recurse(&blk)
    blk.call self
    c.filter { |e| e.is_a?(D) }.each { |e| e.recurse(&blk) }
  end

  def get_size(memo)
    memo[self] = c
      .map { |e| e.is_a?(F) ? e.s : e.get_size(memo) }
      .sum unless memo.has_key?(self)
    memo[self]
  end
end

class F
  attr_accessor :n, :s, :p

  def initialize(n, s, parent)
    @n = n
    @s = s
    @p = parent
  end

  def to_s
    "#{@n} (file, size=#{@s})"
  end
end

class C
  attr_accessor :c, :p

  def initialize(c, params)
    @c = c
    @p = params
  end

  def to_s
    "#{@c} #{@p}"
  end
end

class P
  attr_accessor :root, :path

  def initialize
    @root = D.new("/", nil)
    @cwd = @root
  end

  def populate(input)
    input.each do |ins|
      if ins.is_a?(C) && ins.c == "ls"
        next
      elsif ins.is_a?(C) && ins.c == "cd"
        cd ins.p
      else
        ins.p = @cwd
        @cwd.add_child(ins)
      end
    end
  end

  def cd((path))
    @cwd = @root if path == "/"
    @cwd = @cwd.goto(path) unless path == "/"
  end

  def to_s
    spacing = ""
    string = ""
    @root.recurse do |d|
      string += spacing + "- " + d.to_s + "\n"
      spacing += "  "
      d
        .c
        .filter { |e| e.is_a?(F) }
        .each { |e| string += spacing + "- " + e.to_s + "\n" }
    end
    string
  end
end

def part1(input)
  prog = P.new
  prog.populate(input)
  memo = {}
  prog.root.get_size(memo)
  memo.values.filter { |v| v <= 100_000 }.sum
end

def part2(input)
  prog = P.new
  prog.populate(input)
  memo = {}
  prog.root.get_size(memo)
  ds = memo.each.map { |(k, v)| [k.n, v] }.sort { |(_, v), (_, v2)| v - v2 }
  tot = ds.last.last
  ds.find { |_, v| 70_000_000 > 30_000_000 + tot - v }.last
end

puts "Part 1"
p part1(parse("sample.txt"))
p part1(parse("data.txt"))

puts "Part 2"
p part2(parse("sample.txt"))
p part2(parse("data.txt"))
