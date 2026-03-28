#!/bin/bash

# Функция для получения текущего состояния и вывода JSON
show_status() {
    current=$(asusctl profile get | awk '/Active profile/ {print $NF}')
    case "$current" in
      Performance) text="RAZGON"; class="performance" ;;
      Balanced)    text="STABILIZATION"; class="balanced" ;;
      Quiet)       text="REACTOR SLEEP"; class="quiet" ;;
      *)           text="ASUS ??"; class="unknown" ;;
    esac
    echo "{\"text\": \"$text\", \"class\": \"$class\"}"
}

# Если скрипт запущен с аргументом "next", сначала переключаем
if [ "$1" == "next" ]; then
    current=$(asusctl profile get | awk '/Active profile/ {print $NF}')
    case "$current" in
      Performance) next="Balanced" ;;
      Balanced)    next="Quiet" ;;
      Quiet)       next="Performance" ;;
      *)           next="Balanced" ;;
    esac
    asusctl profile set "$next" > /dev/null 2>&1
fi

# В конце всегда выводим JSON для Waybar
show_status