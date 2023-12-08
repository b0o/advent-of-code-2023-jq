# Advent of Code 2023 in Jq

I'm doing [Advent of Code 2023](https://adventofcode.com/2023) in [jq](https://jqlang.github.io/jq/) because jq is more expressive than you think.

My goal isn't to find the shortest or most performant solution, but to try to write solutions that are as readable and intuitive as possible.

## Usage

Use the `run.sh` script to run the puzzle. Pass the puzzle number as an argument. Runs the example puzzle by default.
To run the actual puzzle, put it in `./${puzzle_number}/input.txt` and run `./run.sh -t ${puzzle_number}`.

```sh
Usage: ./run.sh [options] [puzzle]

Advent of Code 2023 in Jq

Options:
  -h, --help    Show this help message and exit
  -e, --example Run example puzzle (example.txt) (default)
  -t, --test    Run actual puzzle (input.txt)
  -w, --watch   Watch for changes and run puzzle
```

## Solutions

- ✅ [01-1](https://github.com/b0o/advent-of-code-2023-jq/blob/main/01-1/solution.jq) 
- ✅ [01-2](https://github.com/b0o/advent-of-code-2023-jq/blob/main/01-2/solution.jq) 

## License

[MIT License](https://mit-license.org/)
