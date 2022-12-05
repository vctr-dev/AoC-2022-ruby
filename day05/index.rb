def parse(file)
  crates, instructions = File.read(file).split("\n\n")
  crates =
    crates
      .split("\n")
      .map do |v|
        level = []
        v.split("").each_slice(4) { |(_, b, _, _)| level << b.strip }
        level
      end
      .reverse
  stack_numbers = crates[0]
  stacks = crates[1...crates.length]
  stack_hash = {}
  stack_numbers.each_with_index do |e, i|
    stack = []
    stacks.each { |v| stack << v[i] unless v[i].empty? }
    stack_hash[e] = stack
  end

  ins =
    instructions
      .split("\n")
      .map do |v|
        _, num, _, src, _, dest = v.split(" ")
        [num, src, dest]
      end

  [stack_hash, ins]
end

def part1((s, ins))
  ins.each { |(num, src, dest)| num = num.to_i.times { s[dest] << s[src].pop } }
  s.values.map { |v| v.last }.join
end

def part2((s, ins))
  ins.each { |(num, src, dest)| s[dest].concat(s[src].pop(num.to_i)) }
  s.values.map { |v| v.last }.join
end

p part1(parse("sample.txt"))
p part1(parse("data.txt"))
p part2(parse("sample.txt"))
p part2(parse("data.txt"))
