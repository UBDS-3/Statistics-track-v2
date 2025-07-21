#!/usr/bin/env bash
set -uo pipefail

ALL_TYPES=(solved simplified default)
ALL_LABS=(testing exploratory clustering omics ML regression randomness multivariate)
DEFAULT_ONLY_LABS=(exploratory randomness)

usage() {
  echo "Usage: $(basename "$0") --type <type|all> [--lab <labs|all>]

  Available options:
    type: solved simplified default
    labs: testing exploratory clustering omics ML regression randomness multivariate"
}

die() { echo "Error: $*" >&2; usage; exit 1; }
[[ $# -eq 0 ]] && { usage; exit 1; }

types=() labs=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --type) shift; while [[ $# -gt 0 && $1 != --* ]]; do types+=("$1"); shift; done ;;
    --lab)  shift; while [[ $# -gt 0 && $1 != --* ]]; do labs+=("$1");  shift; done ;;
    *) die "Unknown option $1" ;;
  esac
done
[[ ${#types[@]} -eq 0 ]] && die "--type needs at least one value"

valid_or_die() { local v=$1; shift; local -n arr=$1;
  [[ " ${arr[*]} " == *" $v "* ]] || die "Invalid value $v"
}
expand() { local -n ref=$1 full=$2
  [[ ${ref[*]} == *all* ]] && ref=("${full[@]}")
  for v in "${ref[@]}"; do valid_or_die "$v" full; done
}
expand types ALL_TYPES
[[ ${#labs[@]} -eq 0 ]] && labs=("${ALL_LABS[@]}")
expand labs ALL_LABS

render() {
  local qmd=$1
  local type=$2
  local base=${qmd%.qmd}
  local html="${base}.html"

  echo "Rendering $qmd ($type)"
  case $type in
    solved)     quarto render "$qmd" -P answers:true ;;
    simplified) quarto render "$qmd" -P simplified:true ;;
    default)    quarto render "$qmd" ;;
  esac

  [[ -f $html ]] || die "Render failed: $html not found"
  [[ $type != default ]] && mv "$html" "${base}.${type}.html"
}

shopt -s nullglob
for lab in "${labs[@]}"; do
  qmd_files=(labs/"$lab"/*.qmd)
  [[ ${#qmd_files[@]} -eq 0 ]] && { echo "Skip: no .qmd in $lab"; continue; }

  if [[ " ${DEFAULT_ONLY_LABS[*]} " == *" $lab "* ]]; then
    for qmd in "${qmd_files[@]}"; do render "$qmd" default; done
  else
    for type in "${types[@]}"; do
      for qmd in "${qmd_files[@]}"; do render "$qmd" "$type"; done
    done
  fi
done
shopt -u nullglob
