#!/bin/sh
input=$(cat)

# --- Data extraction ---
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
model=$(echo "$input" | jq -r '.model.display_name // ""')
five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')

# --- Folder: basename of cwd ---
folder=$(basename "$cwd")

# --- Git branch ---
branch=""
if [ -n "$cwd" ]; then
  branch=$(GIT_DIR="$cwd/.git" GIT_WORK_TREE="$cwd" git --no-optional-locks -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null)
fi

# --- ANSI colors (dim-friendly) ---
RESET="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"
CYAN="\033[36m"
YELLOW="\033[33m"
MAGENTA="\033[35m"
GREEN="\033[32m"
RED="\033[31m"
BLUE="\033[34m"

# --- Build output ---
# Folder
printf "${BOLD}${CYAN}%s${RESET}" "$folder"

# Git branch
if [ -n "$branch" ]; then
  printf "  ${YELLOW}%s${RESET}" "$branch"
fi

# Model
if [ -n "$model" ]; then
  printf "  ${MAGENTA}%s${RESET}" "$model"
fi

# Usage progress bar helper function (POSIX sh compatible)
print_usage_bar() {
  label="$1"
  pct="$2"
  used_int=$(printf "%.0f" "$pct")
  bar_width=10
  filled=$(( used_int * bar_width / 100 ))
  empty=$(( bar_width - filled ))

  # Color: green < 60%, yellow < 85%, red >= 85%
  if [ "$used_int" -ge 85 ]; then
    bar_color="$RED"
  elif [ "$used_int" -ge 60 ]; then
    bar_color="$YELLOW"
  else
    bar_color="$GREEN"
  fi

  bar=""
  i=0
  while [ $i -lt $filled ]; do
    bar="${bar}█"
    i=$(( i + 1 ))
  done
  i=0
  while [ $i -lt $empty ]; do
    bar="${bar}░"
    i=$(( i + 1 ))
  done

  printf "  ${DIM}%s${RESET} ${bar_color}%s${RESET} ${DIM}%s%%${RESET}" "$label" "$bar" "$used_int"
}

# Rate limit usage bar (5-hour session limit)
if [ -n "$five_pct" ]; then
  print_usage_bar "5h" "$five_pct"
fi

printf "\n"
