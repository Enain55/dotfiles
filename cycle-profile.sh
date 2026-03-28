#!/bin/bash

# Get current profile
current=$(asusctl profile get | awk '/Active profile/ {print $NF}')

case "$current" in
  Performance)
    next="Balanced"
    text="RAZGON"
    fg="#bf616a"  # Red for Performance
    ;;
  Balanced)
    next="Quiet"
    text="STABILIZATION"
    fg="#fab387"  # Yellow for Balanced
    ;;
  Quiet)
    next="Performance"
    text="REACTOR SLEEP"
    fg="#56b6c2"  # Blue for Quiet
    ;;
  *)
    next="Balanced"
    text="ASUS ??"
    fg="#ffffff"  # Default white
    ;;
esac

# Switch profile
asusctl profile set "$next"

# Output the text and dynamic color for Waybar
echo "<span foreground='$fg' class='asus-profile'>$text</span>"