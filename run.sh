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
  local puzzle="$1"
  local puzzle_dir="$base_dir/$puzzle"
  [[ -z "$puzzle" ]] && usage && exit 1
  [[ ! -d "$puzzle_dir" ]] && echo "Puzzle $puzzle not found" && exit 1
  if [[ "$watch" == 1 ]]; then
    echo "Watching $puzzle_dir"
    {
      echo "${BASH_SOURCE[0]}"
      find "$puzzle_dir" -type f
    } | entr "${BASH_SOURCE[0]}" -W "$@"
  fi
  run_puzzle
}

function run_puzzle() {
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
  perl -pe 'chomp if eof' "$input_file" | # remove trailing newline from end of file
    jq -Rsf "$jq_filter_file"
}

main "$@"
