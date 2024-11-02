#!/bin/sh

# status=$(curl -s 'wttr.in/NewYork?format=%C+|+%t')
# status=$(curl -s 'wttr.in/Maebashi?lang=ja&format=%C+|+%t')
status=$(curl -s 'wttr.in/Maebashi?lang=ja&format=3')
# condition=$(echo $status | awk -F '|' '{print $1}' | tr '[:upper:]' '[:lower:]')
# condition=$(echo $status | awk -F '|' '{print $1}' | tr '[:upper:]' '[:lower:]')
# condition=$(echo $status | awk '{print $2, $3}')
condition=$(echo $status | awk '{gsub(/\+/, "", $3); print $2, $3}')

sketchybar -m --set weather icon="$condition"
