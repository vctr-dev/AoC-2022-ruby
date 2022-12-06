def parse(file)
  File.read(file).split("")
end

def get_index(a, cs)
  cs + a.each_cons(cs).find_index { |a| a.uniq.length == cs }
end

def part1(input)
  get_index(input, 4)
end

def part2(input)
  get_index(input, 14)
end

puts "Part 1"
p part1(parse("sample.txt"))
p part1(parse("data.txt"))

puts "Part 2"
p part2(parse("sample.txt"))
p part2(parse("data.txt"))
