input = File.read("sample.txt").split("\n").map { |s| s.split("") }

def get_priority(a)
  (("a".."z").to_a + ("A".."Z").to_a).index(a) + 1
end

def get_badge(a)
  (a[0] & a[1] & a[2])[0]
end

p input.each_slice(3).to_a.map { |a| get_badge(a) }.sum { |a| get_priority(a) }
