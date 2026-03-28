#!/bin/bash

logfile="/tmp/waybar_watcher_final.log"

# Настройки
off_delay=8     # ~3 сек тишины перед выключением
on_delay=3      # ~1.2 сек стабильности перед включением
check_speed=0.4 

empty_count=0 
stable_count=0
last_workspace=""

wallpaper_with_window="/home/enainandreev/.config/hypr/wallpapers/black_2.jpg"
wallpaper_without_window="/home/enainandreev/.config/hypr/wallpapers/bg_wallpaper_2.jpg"

current_wallpaper=""
monitor=$(hyprctl monitors -j | jq -r '.[0].name')

hyprctl hyprpaper preload "$wallpaper_with_window"
hyprctl hyprpaper preload "$wallpaper_without_window"

while true; do
    # Берем данные один раз
    hypr_data=$(hyprctl activeworkspace -j)
    active_ws=$(echo "$hypr_data" | jq -r '.id')
    window_count=$(hyprctl clients -j | jq "[.[] | select(.workspace.id == $active_ws and .mapped == true)] | length")

    if [ "$active_ws" != "$last_workspace" ]; then
        last_workspace="$active_ws"
        stable_count=0
        empty_count=0
        # Не делаем НИЧЕГО, пока пользователь не остановится
        sleep $check_speed
        continue
    fi

    if [ "$window_count" -gt 0 ]; then
        empty_count=0
        ((stable_count++))

        if [ "$stable_count" -ge "$on_delay" ]; then
            
            if ! pgrep -x "waybar" > /dev/null; then
                pkill -x conky
                nohup waybar >/dev/null 2>&1 &
            fi
            if [ "$current_wallpaper" != "$wallpaper_with_window" ]; then
                echo "Switching to WITH_WINDOW wallpaper" >> "$logfile"
                hyprctl hyprpaper wallpaper "$monitor,$wallpaper_with_window"
                current_wallpaper="$wallpaper_with_window"
            fi
        fi

    else
        stable_count=0
        ((empty_count++))

        if [ "$empty_count" -ge "$off_delay" ]; then
            
            # 1. Waybar & Conky
            if pgrep -x "waybar" > /dev/null; then
                pkill -x waybar
            fi

            if ! pgrep -x "conky" > /dev/null; then
                conky --daemonize --pause=1 &
            fi

            if [ "$current_wallpaper" != "$wallpaper_without_window" ]; then
                echo "Switching to WITHOUT_WINDOW wallpaper" >> "$logfile"
                hyprctl hyprpaper wallpaper "$monitor,$wallpaper_without_window"
                current_wallpaper="$wallpaper_without_window"
            fi
        fi
    fi

    sleep $check_speed
done