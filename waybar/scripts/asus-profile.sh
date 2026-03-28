#!/bin/bash

current=$(asusctl profile get | awk '/Active profile/ {print $NF}')

case "$current" in
  Performance)
    next="Balanced"
    text="RAZGON"
    class="performance"
    ;;
  Balanced)
    next="Quiet"
    text="STABILIZATION"
    class="balanced"
    ;;
  Quiet)
    next="Performance"
    text="REACTOR SLEEP"
    class="quiet"
    ;;
  *)
    next="Balanced"
    text="ASUS ??"
    class="unknown"
    ;;
esac

asusctl profile set "$next" > /dev/null 2>&1

echo "{\"text\": \"$text\", \"class\": \"$class\"}"
