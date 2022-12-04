input = File.read("data.txt").split("\n").map { |v| v.split(" ") }

def outcome_of_round(res)
  score_map = { "X" => 0, "Y" => 3, "Z" => 6 }
  score_map[res]
end

def score_from_shape(opp, res)
  res_offset = { "X" => -1, "Y" => 0, "Z" => 1 }[res]
  res_i = ("A".."C").to_a.index(opp) + res_offset
  ((1..3).to_a + (1..3).to_a)[res_i]
end

def result_of_round(opp, res)
  outcome_of_round(res) + score_from_shape(opp, res)
end

p input.map { |arr| result_of_round(arr[0], arr[1]) }.sum
