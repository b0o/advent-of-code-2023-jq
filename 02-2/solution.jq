map(
  split(": ").[1]
  | split("; ") | map(
    split(", ") | map(
      split(" ") | { key: .[1], value: .[0] | tonumber }
    )
  )
  | flatten
  | group_by(.key)
  | map(max_by(.value) | .value)
  | reduce .[] as $e (1; . * $e)
)
| add
