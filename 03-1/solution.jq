def coords($re):
  map(
    split("")
    | to_entries
    | map(.value | select(test($re)) // false)
  );
def symbols: coords("[^0-9.]");
def numbers: coords("[0-9]");

def get($mat; $r; $c):
  if $r < 0 or $c < 0 then
    false
  else
    ($mat[$r] // [])[$c] // false
  end;

def adjacent($mat; $r; $c):
  get($mat; $r-1; $c-1) or
  get($mat; $r-1; $c+0) or
  get($mat; $r-1; $c+1) or
  get($mat; $r+0; $c-1) or
  get($mat; $r+0; $c+1) or
  get($mat; $r+1; $c-1) or
  get($mat; $r+1; $c+0) or
  get($mat; $r+1; $c+1);

def adjacents($mat):
  to_entries
  | map(
    .key as $row
    | .value
    | to_entries
    | map(
      .key as $col
      | if .value and adjacent($mat; $row; $col) then
          .value
        else
          false
        end
    )
  );

numbers as $numbers
| symbols as $symbols
| $numbers | adjacents($symbols) as $adjnums
| $numbers
| to_entries
| map(
  .key as $row
  | .value | map(. // " ") | join("") | split(" ")
  | reduce .[] as $e ({ offset: 0, entries: [] };
    .offset as $offset
    | if $e != "" then
      .entries += [{
        number: $e,
        coords: (
          $e
          | split("")
          | to_entries
          | map(get($adjnums; $row; $offset + .key) | select(.))
          | select(length > 0)
        ),
      }.number]
    end
    | .offset += ($e | length) + 1
  )
)
| map(.entries | map(tonumber))
| flatten
| add
