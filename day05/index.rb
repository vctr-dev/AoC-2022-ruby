def parse(file)
  crates, instructions = File.read(file).split("\n\n")
  num, *stacks =
    crates
      .split("\n")
      .map { |v| v.split("").each_slice(4).map { |a| a[1].strip } }
      .reverse

  stack_hash = {}
  num.each_with_index do |e, i|
    stack_hash[e] = stacks.map { |v| v[i] }.delete_if { |v| v && v.empty? }
  end

  ins =
    instructions
      .split("\n")
      .map do |v|
        _, num, _, src, _, dest = v.split(" ")
        [num.to_i, src, dest]
      end

  [stack_hash, ins]
end

def part1((s, ins))
  ins.each { |(num, src, dest)| s[dest] += s[src].pop(num).reverse }
  s.values.map { |v| v.last }.join
end

def part2((s, ins))
  ins.each { |(num, src, dest)| s[dest] += s[src].pop(num) }
  s.values.map { |v| v.last }.join
end

p part1(parse("sample.txt"))
p part1(parse("data.txt"))
p part2(parse("sample.txt"))
p part2(parse("data.txt"))
