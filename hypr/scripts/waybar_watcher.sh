#!/bin/bash

logfile="/tmp/waybar_watcher_final.log"

# Настройки (в итерациях цикла)
off_delay=4     
on_delay=2      
check_speed=0.4 

empty_count=0 
stable_count=0
last_workspace=""
# Состояние: 0 - пустой стол, 1 - окна есть
current_mode=-1 

wallpaper_with_window="/home/enainandreev/.config/hypr/wallpapers/black_2.jpg"
wallpaper_without_window="/home/enainandreev/.config/hypr/wallpapers/bg_wallpaper_2.jpg"

# Получаем имя монитора (берем первый активный)
monitor=$(hyprctl monitors -j | jq -r '.[0].name')

# Предзагрузка обоев (обязательно!)
hyprctl hyprpaper preload "$wallpaper_with_window" >/dev/null 2>&1
hyprctl hyprpaper preload "$wallpaper_without_window" >/dev/null 2>&1

while true; do
    # 1. Получаем данные одним вызовом
    ws_data=$(hyprctl activeworkspace -j)
    active_ws=$(echo "$ws_data" | jq -r '.id')
    window_count=$(echo "$ws_data" | jq -r '.windows')

    # Сброс при переключении стола
    if [ "$active_ws" != "$last_workspace" ]; then
        last_workspace="$active_ws"
        stable_count=0
        empty_count=0
    fi

    # 2. Логика определения состояния
    if [ "$window_count" -gt 0 ]; then
        empty_count=0
        ((stable_count++))
        
        # Если окна стабильно открыты и мы еще не в "активном" режиме
        if [ "$stable_count" -ge "$on_delay" ] && [ "$current_mode" -ne 1 ]; then
            
            # Действия для ВКЛЮЧЕНИЯ
            pkill -x conky >/dev/null 2>&1
            if ! pgrep -x "waybar" > /dev/null; then
                waybar >/dev/null 2>&1 &
            fi
            
            # Смена обоев (только если нужно)
            hyprctl hyprpaper wallpaper "$monitor,$wallpaper_with_window" >/dev/null 2>&1
            
            current_mode=1
            echo "$(date): Mode -> ACTIVE (Windows detected)" >> "$logfile"
        fi
    else
        stable_count=0
        ((empty_count++))

        # Если стол стабильно пуст и мы еще не в "пустом" режиме
        if [ "$empty_count" -ge "$off_delay" ] && [ "$current_mode" -ne 0 ]; then
            
            # Действия для ВЫКЛЮЧЕНИЯ
            pkill -9 -x waybar >/dev/null 2>&1
            
            if ! pgrep -x "conky" > /dev/null; then
                conky --daemonize --pause=1 >/dev/null 2>&1
            fi

            # Смена обоев (только если нужно)
            hyprctl hyprpaper wallpaper "$monitor,$wallpaper_without_window" >/dev/null 2>&1
            
            current_mode=0
            echo "$(date): Mode -> EMPTY (Desktop clear)" >> "$logfile"
        fi
    fi

    sleep "$check_speed"
done
