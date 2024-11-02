#!/bin/sh

# The $NAME variable is passed from sketchybar and holds the name of
# the item invoking this script:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting

# sketchybar --set "$NAME" label="$(date '+%d/%m %H:%M')"
get_japanese_weekday() {
    case $(date +%u) in
        1) echo "月" ;;
        2) echo "火" ;;
        3) echo "水" ;;
        4) echo "木" ;;
        5) echo "金" ;;
        6) echo "土" ;;
        7) echo "日" ;;
    esac
}
weekday=$(get_japanese_weekday)

sketchybar --set "$NAME" label="$(date '+%m月%d日')(${weekday}) $(date '+%H:%M')"

