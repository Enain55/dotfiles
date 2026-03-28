#!/bin/bash

logfile="/tmp/waybar_watcher_final.log"
delay=3 

# Обои
wallpaper_with_window="/home/enainandreev/.config/hypr/wallpapers/black_2.jpg"
wallpaper_without_window="/home/enainandreev/.config/hypr/wallpapers/bg_wallpaper_2.jpg"

current_wallpaper=""
waybar_visible=true
conky_visible=false
empty_since=0

monitor=$(hyprctl monitors -j | jq -r '.[0].name')

start_conky() {
    conky --daemonize --pause=1 & 
    conky_visible=true
}

stop_conky() {
    pkill -x conky
    conky_visible=false
}

while true; do
    active_workspace=$(hyprctl activeworkspace -j | jq -r '.id')
    window_count=$(hyprctl clients -j | jq "[.[] | select(.workspace.id == $active_workspace and .mapped == true)] | length")

    if [ "$window_count" -gt 0 ]; then
        empty_since=0

        if ! $waybar_visible; then
            echo "Windows detected. Bringing Waybar back..." >> "$logfile"
            nohup waybar >/dev/null 2>&1 &
            waybar_visible=true
            stop_conky
        fi

        if [ "$current_wallpaper" != "$wallpaper_with_window" ]; then
            hyprctl hyprpaper preload "$wallpaper_with_window"
            hyprctl hyprpaper wallpaper "$monitor,$wallpaper_with_window"
            current_wallpaper="$wallpaper_with_window"
        fi

    else
        if [ "$empty_since" -eq 0 ]; then
            empty_since=$(date +%s)
        fi

        now=$(date +%s)
        elapsed=$((now - empty_since))
        if [ "$elapsed" -ge "$delay" ] && $waybar_visible; then
            echo "Desktop empty for $delay seconds. Switching to Conky mode..." >> "$logfile"
            
            # Прячем Waybar
            pkill -x waybar
            waybar_visible=false
            
            # Запускаем Conky
            start_conky
            
            # Меняем обои на чистые
            if [ "$current_wallpaper" != "$wallpaper_without_window" ]; then
                hyprctl hyprpaper preload "$wallpaper_without_window"
                hyprctl hyprpaper wallpaper "$monitor,$wallpaper_without_window"
                current_wallpaper="$wallpaper_without_window"
            fi
        fi
    fi

    sleep 0.5
done