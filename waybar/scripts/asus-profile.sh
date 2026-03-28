#!/bin/bash

# Отримуємо поточний профіль
current=$(asusctl profile get | awk '/Active profile/ {print $NF}')

# Визначаємо параметри залежно від профілю
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

# Перемикаємо профіль (якщо скрипт викликається для зміни)
# Якщо цей скрипт просто для відображення, цю строку можна прибрати
asusctl profile set "$next" > /dev/null 2>&1

# ВИВІД У ФОРМАТІ JSON (Критично для класів)
echo "{\"text\": \"$text\", \"class\": \"$class\"}"
