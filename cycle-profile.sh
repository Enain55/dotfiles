#!/bin/bash

# Get current profile
current=$(asusctl profile get | awk '/Active profile/ {print $NF}')

case "$current" in
  Performance)
    next="Balanced"
    ;;
  Balanced)
    next="Quiet"
    ;;
  Quiet)
    next="Performance"
    ;;
  *)
    next="Balanced"
    ;;
esac

# Switch profile
asusctl profile set "$next"
