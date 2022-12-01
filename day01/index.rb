input = File.read("data.txt").split("\n\n")

p input.map { |s| s.split("\n").map { |v| v.to_i }.sum }.max(3).sum
