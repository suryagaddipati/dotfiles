#!/usr/bin/env bash
# <swiftbar.title>Bluetooth</swiftbar.title>
# <swiftbar.refresh>10s</swiftbar.refresh>
# <swiftbar.dependencies>blueutil, jq</swiftbar.dependencies>
# <swiftbar.author>surya</swiftbar.author>

set -euo pipefail

PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

if ! command -v blueutil >/dev/null 2>&1; then
  echo "BT ?"
  echo "---"
  echo "Install blueutil (brew install blueutil)"
  exit 0
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "BT ?"
  echo "---"
  echo "Install jq (brew install jq)"
  exit 0
fi

power=$(blueutil --power 2>/dev/null || echo "0")
paired_json=$(blueutil --paired --format json 2>/dev/null || echo "[]")

connected_count=$(printf "%s" "$paired_json" | jq '[.[] | select(.connected == true)] | length')
first_connected=$(printf "%s" "$paired_json" | jq -r '.[] | select(.connected == true) | .name // .address' | head -n 1)

if [[ "$power" == "1" ]]; then
  icon="🔵"
elif [[ "$power" == "0" ]]; then
  icon="⚪️"
else
  icon="❓"
fi

if [[ "$power" != "1" ]]; then
  title="BT off"
elif [[ "$connected_count" -gt 0 ]]; then
  extra=$((connected_count - 1))
  if [[ "$extra" -gt 0 ]]; then
    title="$icon $first_connected +$extra"
  else
    title="$icon $first_connected"
  fi
else
  title="$icon BT"
fi

echo "$title"
echo "---"

if [[ "$power" == "1" ]]; then
  echo "Turn Bluetooth Off | bash='blueutil --power 0' terminal=false refresh=true"
else
  echo "Turn Bluetooth On | bash='blueutil --power 1' terminal=false refresh=true"
fi

echo "Refresh | refresh=true"
echo "---"

echo "Connected devices ($connected_count)"
if [[ "$connected_count" -gt 0 ]]; then
  printf "%s" "$paired_json" | jq -r '.[] | select(.connected == true) | "--\(.name // .address) | bash=\"blueutil --disconnect \(.address)\" terminal=false refresh=true"'
else
  echo "--None"
fi

echo "Paired devices"
unconnected_count=$(printf "%s" "$paired_json" | jq '[.[] | select(.paired == true and .connected != true)] | length')
if [[ "$unconnected_count" -gt 0 ]]; then
  printf "%s" "$paired_json" | jq -r '.[] | select(.paired == true and .connected != true) | "--Connect \(.name // .address) | bash=\"blueutil --connect \(.address)\" terminal=false refresh=true"'
else
  echo "--None"
fi
