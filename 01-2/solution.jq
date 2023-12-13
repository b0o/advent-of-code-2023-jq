# Generates an object like { "0": 0, "1": 1, ... }
def gen_digits:
  [range(0; 10)] | reduce .[] as $i ({}; .["\($i)"] = $i);

# Generates an object like { "one": 1, "two": 2, ... }
def gen_words:
  ["one","two","three","four","five","six","seven","eight","nine"]
  | to_entries
  | reduce .[] as {$key,$value} ({}; .[$value] = $key + 1);

# Joins digits and words and converts objects and converts to an array of objects like
# [{ key: "one", value: 1 }, { key: "two", value: 2 }, ... ]
def gen_nums: gen_digits + gen_words  | to_entries;

# Given an input like { key: "one", value: 1 }, find the key  in the string $line.
# If $first is true, find the index of the first occurrence; otherwise, find the index of the last.
# Outputs an object like { num: 1, index: 4 } if found, otherwise nothing.
def find_num($line; $first):
  . as $n
  | {}
  | .num = $n.value
  | .index = ($line | if $first then index($n.key) else rindex($n.key) end)
  | select(.index);

# Find all nums in the input, if $first is true find from left to right,
# otherwise find from right to left.
def find_nums($first):
  . as $line
  | gen_nums
  | map(find_num($line; $first));

# Find the first (if $first is true) or last num in the input string.
def get_num($first):
  find_nums($first)
  | if $first then min_by(.index) else max_by(.index) end
  | .num;
def first_num: get_num(true);
def last_num: get_num(false);

map(
   [first_num, last_num]
   | join("")
   | tonumber
  )
| add
