#!/bin/bash

rfkill unblock bluetooth
bluetoothctl power on

devices=$(bluetoothctl devices | cut -d' ' -f2-)
connected_devices=$(bluetoothctl devices Connected | cut -d' ' -f2-)

menu_options=""

while IFS= read -r device; do
  mac=$(echo "$device" | awk '{print $1}')
  name=$(echo "$device" | cut -d' ' -f2-)

  if echo "$connected_devices" | grep -q "$mac"; then
    menu_options+="  $name (Connected)\n"
  else
    menu_options+="  $name\n"
  fi
done <<< "$devices"

menu_options+="󰂯  Bluetooth Settings\n󰂲  Turn Off Bluetooth"

selection=$(echo -e "$menu_options" | omarchy-launch-walker --dmenu --width 350 --minheight 1 --maxheight 630 -p "Bluetooth…" 2>/dev/null)

if [[ -z "$selection" ]]; then
  exit 0
fi

if [[ "$selection" == *"Bluetooth Settings"* ]]; then
  omarchy-launch-or-focus-tui bluetui
elif [[ "$selection" == *"Turn Off"* ]]; then
  bluetoothctl power off
  notify-send "Bluetooth" "Bluetooth turned off"
else
  device_name=$(echo "$selection" | sed 's/^  //; s/ (Connected)$//')
  mac=$(bluetoothctl devices | grep "$device_name" | awk '{print $2}')

  if [[ "$selection" == *"(Connected)"* ]]; then
    bluetoothctl disconnect "$mac"
    notify-send "Bluetooth" "Disconnected from $device_name"
  else
    bluetoothctl connect "$mac"
    notify-send "Bluetooth" "Connected to $device_name"
  fi
fi
