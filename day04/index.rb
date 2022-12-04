input =
  File
    .read("data.txt")
    .split("\n")
    .map do |s|
      s
        .split(",")
        .map { |v| v.split("-").map { |i| i.to_i } }
        .map { |(s, e)| (s..e).to_a }
    end

def contains_each_other?((first, second))
  (first - second).empty? || (second - first).empty?
end

def overlaps?((first, second))
  first.intersect? second
end

p input.filter { |a| overlaps?(a) }.length
