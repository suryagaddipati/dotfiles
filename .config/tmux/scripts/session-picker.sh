#!/usr/bin/env bash
set -euo pipefail

if ! command -v tmux >/dev/null 2>&1; then
  echo "tmux is not installed"
  exit 1
fi

if ! command -v fzf >/dev/null 2>&1; then
  echo "fzf is not installed"
  exit 1
fi

inside_tmux=false
if [ -n "${TMUX:-}" ]; then
  inside_tmux=true
fi

create_session() {
  local name=""
  local cwd="${HOME}"

  read -r -p "New session name: " name
  name="${name// /-}"

  if [ -z "${name}" ]; then
    exit 0
  fi

  if ! tmux has-session -t "${name}" 2>/dev/null; then
    tmux new-session -d -s "${name}" -c "${cwd}"
  fi

  if [ "${inside_tmux}" = true ]; then
    tmux switch-client -t "${name}"
  else
    exec tmux attach-session -t "${name}"
  fi
}

sessions="$(tmux list-sessions -F "#{session_name}" 2>/dev/null || true)"

if [ -z "${sessions}" ]; then
  create_session
fi

selection="$(
  {
    printf "__new__\n"
    printf "%s\n" "${sessions}"
  } | fzf \
      --prompt="Session > " \
      --header="Enter: switch   Ctrl-N: new session" \
      --layout=reverse \
      --border \
      --expect=ctrl-n \
      --bind="ctrl-n:accept"
)"

pressed_key="$(printf "%s\n" "${selection}" | sed -n '1p')"
selected="$(printf "%s\n" "${selection}" | sed -n '2p')"

if [ -z "${selected}" ]; then
  exit 0
fi

if [ "${pressed_key}" = "ctrl-n" ] || [ "${selected}" = "__new__" ]; then
  create_session
fi

if [ "${inside_tmux}" = true ]; then
  tmux switch-client -t "${selected}"
else
  exec tmux attach-session -t "${selected}"
fi
