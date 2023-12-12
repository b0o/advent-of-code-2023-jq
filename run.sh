#!/usr/bin/env bash
set -euo pipefail

base_dir="$(dirname "${BASH_SOURCE[0]}")"

function usage() {
  cat <<EOF
Usage: $0 [options] [puzzle]

Advent of Code 2023 in Jq

Options:
  -h, --help    Show this help message and exit
  -e, --example Run example puzzle (example.txt) (default)
  -t, --test    Run actual puzzle (input.txt)
  -w, --watch   Watch for changes and run puzzle
EOF
  exit 1
}

function main() {
  local use_example=1
  local watch=-1
  local -a opts=("$@")
  while getopts ":hetwW" opt; do
    case "$opt" in
    h) usage ;;
    e) use_example=1 ;;
    t) use_example=0 ;;
    w) [[ "$watch" == -1 ]] && watch=1 ;;
    W) watch=0 ;;
    *) usage ;;
    esac
  done
  shift $((OPTIND - 1))
  if [[ "$watch" == 1 ]]; then
    local puzzle="${1:-}"
    echo "Watching for changes"
    local -a entr_opts=()
    local -a files=("${BASH_SOURCE[0]}")
    if [[ -n "$puzzle" ]]; then
      mapfile -t files < <(find "$base_dir/$puzzle" -type f)
    else
      entr_opts+=(-p -d)
      mapfile -t files < <(find "$base_dir/"[0-9]* -type f)
    fi
    printf '%s\n' "${files[@]}" | entr "${entr_opts[@]}" "${BASH_SOURCE[0]}" -W "${opts[@]}" /_
    exit $?
  fi
  if [[ $watch -eq 0 && "${1:-}" =~ ^[0-9]+$ ]]; then
    exit 0
  fi
  local -a puzzles=()
  if [[ $# -gt 0 ]]; then
    puzzles=("$@")
  else
    mapfile -t puzzles < <(find "$base_dir/"[0-9]* -type f -name "solution.jq" -printf "%h\n" | sort | xargs -n1 basename)
  fi
  for puzzle in "${puzzles[@]}"; do
    run_puzzle "$puzzle"
  done
}

function run_puzzle() {
  local puzzle="${1:-}"
  if [[ -f "$puzzle" && $watch -eq 0 ]]; then
    puzzle="$(basename "$(dirname "$puzzle")")"
  fi
  local puzzle_dir="$base_dir/$puzzle"
  [[ -z "$puzzle" ]] && usage && exit 1
  [[ ! -d "$puzzle_dir" ]] && echo "Puzzle $puzzle not found" && exit 1
  local input
  if [[ "$use_example" == 1 ]]; then
    input="example.txt"
  else
    input="input.txt"
  fi
  local jq_filter_file="$base_dir/$puzzle/solution.jq"
  local input_file="$base_dir/$puzzle/$input"
  [[ ! -f "$jq_filter_file" ]] && echo "Solution file not found: $jq_filter_file" && exit 1
  [[ ! -f "$input_file" ]] && echo "Input file not found: $input_file" && exit 1
  echo "$puzzle <- $input"
  jq -Rs 'split("\n")[0:-1]' "$input_file" | # split into lines and remove trailing newline from EOF
    jq -f "$jq_filter_file"
}

main "$@"
