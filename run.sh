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
  local puzzle
  local use_example=1
  local watch=false
  while getopts ":hetw" opt; do
    case "$opt" in
    h)
      usage
      ;;
    e)
      use_example=1
      ;;
    t)
      use_example=0
      ;;
    w)
      watch=true
      ;;
    *)
      usage
      ;;
    esac
  done
  shift $((OPTIND - 1))
  puzzle="$1"
  if [[ -z "$puzzle" ]]; then
    usage
  fi
  if [[ "$watch" == true ]]; then
    watch_puzzle "$puzzle" "$use_example"
  else
    run_puzzle "$puzzle" "$use_example"
  fi
}

function watch_puzzle() {
  local puzzle="$1"
  local use_example="$2"
  local input
  if [[ "$use_example" == 1 ]]; then
    input="example.txt"
  else
    input="input.txt"
  fi
  local jq_filter_file="$base_dir/$puzzle/solution.jq"
  local input_file="$base_dir/$puzzle/$input"
  local -a flags=()
  if [[ $use_example == 1 ]]; then
    flags+=("-e")
  else
    flags+=("-t")
  fi
  echo -e "$jq_filter_file\n$input_file" | entr "${BASH_SOURCE[0]}" "${flags[@]}" "$puzzle"
}

function run_puzzle() {
  local puzzle="$1"
  local use_example="$2"
  local input
  if [[ "$use_example" == 1 ]]; then
    input="example.txt"
  else
    input="input.txt"
  fi
  local jq_filter_file="$base_dir/$puzzle/solution.jq"
  local input_file="$base_dir/$puzzle/$input"
  echo "$puzzle <- $input"
  jq -Rsf "$jq_filter_file" "$input_file"
}

main "$@"
