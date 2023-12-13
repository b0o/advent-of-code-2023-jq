def possible($bag):
  to_entries | reduce .[] as $e (true; . and $e.value <= $bag[$e.key]);

map(
  split(": ")
  | {
    game: .[0] | split(" ") | .[1],
    records: (
      .[1] | split("; ") | map(
        split(", ") | map(
          split(" ") | { key: .[1], value: .[0] | tonumber }
        )
      )
      | flatten
      | group_by(.key)
      | map(max_by(.value))
      | from_entries
    )
  }
  | select(.records | possible({ red: 12, green: 13, blue: 14 }))
  | .game
  | tonumber
) | add
