def parse(file)
  File.read(file).split("\n")
end

class Cpu
  attr_accessor :collect
  def initialize
    @x = 1
    @cycle = 0
  end

  def run_cycle(&blk)
    blk.call(@x, @cycle)
    @cycle += 1
  end

  def reset_cycle
    @cycle = 1
  end

  def run(prog, &blk)
    reset_cycle
    prog << "noop"
    prog.each do |ins|
      if ins == "noop"
        run_cycle(&blk)
        next
      else
        _, v = ins.split(" ")
        2.times { run_cycle(&blk) }
        @x += v.to_i
      end
    end
  end
end

def part1(input)
  cpu = Cpu.new
  collect = []
  cpu.run(input) { |x, cycle| collect << x * cycle if (cycle - 20) % 40 == 0 }
  collect.sum
end

def part2(input)
  cpu = Cpu.new
  collect = []
  cpu.run(input) { |x, cycle| collect << [x, cycle] }
  collect.filter! { |(x, cycle)| cycle <= 240 }
  res = ""
  collect.each_slice(40) do |a|
    row = ""
    a.each do |(x, cycle)|
      row += (x - 1..x + 1).include?((cycle - 1) % 40) ? "#" : "."
    end
    res += row + "\n"
  end
  res
end

# puts "Part 1"
p part1(parse("sample.txt"))
p part1(parse("sample2.txt"))
p part1(parse("data.txt"))

# puts
puts "Part 2"
puts part2(parse("sample2.txt"))
puts part2(parse("data.txt"))
