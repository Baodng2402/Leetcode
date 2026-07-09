#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$script_dir"

python3 "$script_dir/generate-progress.py"

difficulties=("Easy" "Medium" "Hard")

count_files() {
  local folder="$1"
  if [[ ! -d "$folder" ]]; then
    printf '0'
    return
  fi

  find "$folder" -maxdepth 1 -type f ! -name '.*' | wc -l | tr -d ' '
}

list_files() {
  local folder="$1"
  if [[ ! -d "$folder" ]]; then
    return
  fi

  find "$folder" -maxdepth 1 -type f ! -name '.*' | while IFS= read -r file; do
    local base
    local sort_id
    base="$(basename "$file")"
    sort_id="999999"
    if [[ "$base" =~ ^\[([0-9]+)\] ]]; then
      sort_id="${BASH_REMATCH[1]}"
    fi
    printf '%06d\t%s\n' "$sort_id" "$file"
  done | sort -n | cut -f2-
}

escape_cell() {
  printf '%s' "$1" | sed 's/|/\\|/g'
}

make_slug() {
  printf '%s' "$1" \
    | tr '[:upper:]' '[:lower:]' \
    | tr -d "'\`" \
    | sed -E 's/&/ and /g; s/[()]//g; s/[^a-z0-9]+/-/g; s/^-+//; s/-+$//'
}

write_solution_rows() {
  local difficulty="$1"
  local folder="src/$difficulty"
  local has_files="false"

  while IFS= read -r file; do
    [[ -z "$file" ]] && continue
    has_files="true"

    local base
    local relative_path
    local id
    local title
    local slug
    local problem_cell
    local solution_cell

    base="$(basename "$file")"
    relative_path="${file#./}"
    id="-"
    title="${base%.*}"

    if [[ "$base" =~ ^\[([0-9]+)\](.+)\.[^.]+$ ]]; then
      id="${BASH_REMATCH[1]}"
      title="${BASH_REMATCH[2]}"
    fi

    slug="$(make_slug "$title")"
    if [[ -n "$slug" ]]; then
      problem_cell="[$(escape_cell "$title")](https://leetcode.com/problems/$slug/)"
    else
      problem_cell="$(escape_cell "$title")"
    fi
    solution_cell="[View](<$relative_path>)"

    printf '| %s | %s | %s |\n' "$id" "$problem_cell" "$solution_cell"
  done < <(list_files "$folder")

  if [[ "$has_files" == "false" ]]; then
    printf '| - | No solutions yet | - |\n'
  fi
}

easy_count="$(count_files "src/Easy")"
medium_count="$(count_files "src/Medium")"
hard_count="$(count_files "src/Hard")"
total_count=$((easy_count + medium_count + hard_count))

{
  printf '# LeetCode Progress\n\n'
  printf 'Solutions are organized by difficulty under `src/Easy`, `src/Medium`, and `src/Hard`.\n\n'
  printf '![Progress](./progress.svg)\n\n'

  printf '## Summary\n\n'
  printf '| Difficulty | Solved |\n'
  printf '| --- | ---: |\n'
  printf '| Easy | %s |\n' "$easy_count"
  printf '| Medium | %s |\n' "$medium_count"
  printf '| Hard | %s |\n' "$hard_count"
  printf '| Total | %s |\n\n' "$total_count"

  printf '## Solutions\n\n'
  for difficulty in "${difficulties[@]}"; do
    printf '### %s\n\n' "$difficulty"
    printf '| # | Problem | Solution |\n'
    printf '| ---: | --- | --- |\n'
    write_solution_rows "$difficulty"
    printf '\n'
  done

  printf '## Workflow\n\n'
  printf '1. Use the LeetCode VS Code extension and choose `Code Now`.\n'
  printf '2. The solution file is created under `src/${difficulty}`.\n'
  printf '3. Run `bash update-readme.sh` to refresh this README and `progress.svg`.\n'
  printf '4. Run `bash push.sh` to update README, commit, and push.\n'
} > README.md

printf 'Updated README.md and progress.svg\n'
