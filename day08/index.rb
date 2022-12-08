def parse(file)
  File.read(file).split("\n").map { |a| a.split("").map { |b| b.to_i } }
end

class Matrix
  attr_accessor :matrix

  def initialize(matrix)
    @matrix = matrix
  end

  def get_col(n)
    matrix.map { |r| r[n] }.flatten
  end

  def get_row(n)
    return matrix[n]
  end

  def each_col
    matrix.each_index { |i| yield matrix.map { |r| r[i] }.flatten, i }
  end

  def each_row
    matrix.each_with_index { |r, i| yield r, i }
  end

  def each_with_coord
    matrix.each_with_index do |row, y|
      row.each_with_index { |v, x| yield v, [x, y] }
    end
  end

  def to_s
    @matrix.to_s
  end
end

# x, y is visible => all trees b/w edge and it is shorter
def visible(a)
  max = -1
  indexes = []
  a.each_with_index do |v, i|
    if v > max
      max = v
      indexes << i
    end
  end
  max = -1
  a.each_with_index.to_a.reverse.each do |v, i|
    if v > max
      max = v
      indexes << i
    end
  end
  indexes
end

def part1(input)
  matrix = Matrix.new(input)
  collect = []
  matrix.each_col { |a, x| collect += visible(a).map { |y| [x, y] } }
  matrix.each_row { |a, y| collect += visible(a).map { |x| [x, y] } }
  collect.uniq.sort.length
end

def get_viewing_distance(a)
  ar = a.each_with_index.to_a
  # looking right
  o =
    ar.map do |v, i|
      [
        (
          ar[i + 1...ar.length].find_index { |e, _| e >= v } ||
            ar.length - 2 - i
        ) + 1,
        i
      ]
    end

  r =
    ar.reverse.map do |v, i|
      [(ar[0...i].reverse.find_index { |e, _| e >= v } || i - 1) + 1, i]
    end
  o + r
end
def part2(input)
  matrix = Matrix.new(input)
  # { [x,y] => [1,2,3,4]}
  empty = {}
  matrix.each_with_coord { |_, coord| empty[coord] = [] }
  matrix.each_col do |col, x|
    get_viewing_distance(col).each { |(d, y)| empty[[x, y]] << d }
  end
  matrix.each_row do |row, y|
    get_viewing_distance(row).each { |(d, x)| empty[[x, y]] << d }
  end
  empty.values.map { |v| v.inject(:*) }.max
end

puts "Part 1"
p part1(parse("sample.txt"))
p part1(parse("data.txt"))

puts
puts "Part 2"
p part2(parse("sample.txt"))
p part2(parse("data.txt"))
