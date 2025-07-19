#!/usr/bin/env bash
set -euo pipefail

ALL_TYPES=(solved simplified default)
ALL_LABS=(testing exploratory clustering omics ML regression randomness multivariate)

usage() {
  echo "Usage: $(basename "$0") --type TYPE --lab LAB

  Accepted options:
    --type: solved|simplified|default|all
    --lab: testing|exploratory|clustering|omics|ML|regression|randomness|multivariate|all"
}

die() { echo "Error: $*" >&2; exit 1; }

[[ $# -eq 0 ]] && { usage; exit 1; }

TYPE= LAB=
while [[ $# -gt 0 ]]; do
  case "$1" in
    --type) TYPE="$2"; shift 2 ;;
    --lab)  LAB="$2";  shift 2 ;;
    *) die "Unknown option $1" ;;
  esac
done
[[ -z $TYPE || -z $LAB ]] && die "Both --type and --lab are required"

expand() {
  local val=$1; shift
  local -n all=$1
  [[ $val == all ]] && printf '%s\n' "${all[@]}" || {
    for v in "${all[@]}"; do [[ $v == "$val" ]] && { echo "$val"; return; }; done
    die "Invalid value $val"
  }
}
types=($(expand "$TYPE" ALL_TYPES))
labs=($(expand "$LAB" ALL_LABS))

render() {
  local lab=$1 type=$2
  local qmd=labs/$lab/$lab.qmd
  [[ -f $qmd ]] || die "Missing $qmd"

  echo "Rendering $qmd ($type)"
  case $type in
    solved)
      quarto render "$qmd" -P answers:true
      ;;
    simplified)
      quarto render "$qmd" -P simplified:true
      ;;
    default)
      quarto render "$qmd"
      ;;
  esac

  local src=labs/$lab/$lab.html
  [[ -f $src ]] || die "Quarto did not create $src"

  if [[ $type != default ]]; then
    local dst=labs/$lab/${lab}.${type}.html
    mv "$src" "$dst"
  fi
}

for l in "${labs[@]}"; do
  for t in "${types[@]}"; do
    render "$l" "$t"
  done
done

