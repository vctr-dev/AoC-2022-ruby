input = File.read("data.txt").split("\n").map { |s| s.split("") }

def get_priority(a)
  (("a".."z").to_a + ("A".."Z").to_a).index(a) + 1
end

def get_dup(a)
  len = a.length
  (a.first(len / 2) & a.last(len / 2))[0]
end

p input.map { |a| get_dup(a) }.map { |a| get_priority(a) }.sum
