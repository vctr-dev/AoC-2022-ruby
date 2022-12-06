def parse(file)
  File.read(file).split("")
end

def part1(input)
  index = 0
  input.each_with_index do |_, i|
    index = i + 4 if index == 0 &&
      (input[i...i + 4] | input[i...i + 4]).length == 4
  end
  index
end

def part2(input)
  index = 0
  input.each_with_index do |_, i|
    index = i + 14 if index == 0 &&
      (input[i...i + 14] | input[i...i + 14]).length == 14
  end
  index
end

puts "Part 1"
p part1(parse("sample.txt"))
p part1(parse("data.txt"))

puts "Part 2"
p part2(parse("sample.txt"))
p part2(parse("data.txt"))
