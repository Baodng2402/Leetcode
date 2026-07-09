#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$script_dir"

python3 "$script_dir/generate-progress.py"

difficulties=("Easy" "Medium" "Hard")
difficulty_emoji=("🟢" "🟡" "🔴")

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
    solution_cell="[📄 View](<$relative_path>)"

    printf '| %s | %s | %s |\n' "$id" "$problem_cell" "$solution_cell"
  done < <(list_files "$folder")

  if [[ "$has_files" == "false" ]]; then
    printf '| — | *No solutions yet* | — |\n'
  fi
}

easy_count="$(count_files "src/Easy")"
medium_count="$(count_files "src/Medium")"
hard_count="$(count_files "src/Hard")"
total_count=$((easy_count + medium_count + hard_count))

{
  printf '<div align="center">\n\n'
  printf '# 🧠 LeetCode Solutions\n\n'
  printf '*Personal problem-solving journal — organized by difficulty*\n\n'
  printf '![Progress](./progress.svg)\n\n'
  printf '[![Total](https://img.shields.io/badge/Total-%s-ffa116?style=for-the-badge&logo=leetcode&logoColor=white)](https://leetcode.com)\n' "$total_count"
  printf '[![Easy](https://img.shields.io/badge/Easy-%s-00b8a3?style=for-the-badge)](src/Easy)\n' "$easy_count"
  printf '[![Medium](https://img.shields.io/badge/Medium-%s-ffc01e?style=for-the-badge&labelColor=333)](src/Medium)\n' "$medium_count"
  printf '[![Hard](https://img.shields.io/badge/Hard-%s-ff375f?style=for-the-badge)](src/Hard)\n\n' "$hard_count"
  printf '</div>\n\n'

  printf '%s\n\n' '---'
  printf '## 📊 Summary\n\n'
  printf '| Difficulty | Solved | Share |\n'
  printf '|:-----------|-------:|------:|\n'

  share_of_total() {
    local count="$1"
    if [[ "$total_count" -eq 0 ]]; then
      printf '0%%'
      return
    fi
    printf '%s%%' "$(( count * 100 / total_count ))"
  }

  printf '| 🟢 Easy | **%s** | %s |\n' "$easy_count" "$(share_of_total "$easy_count")"
  printf '| 🟡 Medium | **%s** | %s |\n' "$medium_count" "$(share_of_total "$medium_count")"
  printf '| 🔴 Hard | **%s** | %s |\n' "$hard_count" "$(share_of_total "$hard_count")"
  printf '| **Total** | **%s** | 100%% |\n\n' "$total_count"

  printf '## 📁 Solutions\n\n'
  printf '> Solutions live under `src/Easy`, `src/Medium`, and `src/Hard`.\n\n'

  get_count() {
    case "$1" in
      Easy) printf '%s' "$easy_count" ;;
      Medium) printf '%s' "$medium_count" ;;
      Hard) printf '%s' "$hard_count" ;;
    esac
  }

  for index in "${!difficulties[@]}"; do
    difficulty="${difficulties[$index]}"
    emoji="${difficulty_emoji[$index]}"
    count="$(get_count "$difficulty")"

    printf '<details%s>\n' "$( [[ "$count" -gt 0 ]] && printf ' open' )"
    printf '<summary><b>%s %s</b> — %s problem(s)</summary>\n\n' "$emoji" "$difficulty" "$count"
    printf '| # | Problem | Solution |\n'
    printf '|--:|:--------|:--------:|\n'
    write_solution_rows "$difficulty"
    printf '\n</details>\n\n'
  done

  printf '%s\n\n' '---'
  printf '## ⚙️ Workflow\n\n'
  printf '| Step | Action |\n'
  printf '|:-----|:-------|\n'
  printf '| 1 | Open a problem in the **LeetCode VS Code** extension and click `Code Now` |\n'
  printf '| 2 | Solution file is saved to `src/{difficulty}/[id]Problem Name.java` |\n'
  printf '| 3 | Refresh docs: `bash update-readme.sh` |\n'
  printf '| 4 | Commit & push: `bash push.sh` |\n\n'
  printf '```bash\n'
  printf '# Quick refresh\n'
  printf 'bash update-readme.sh\n\n'
  printf '# Refresh + commit + push\n'
  printf 'bash push.sh\n'
  printf '```\n'
} > README.md

printf 'Updated README.md and progress.svg\n'
