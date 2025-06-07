#!/bin/bash

SLACK_INFO=$(lsappinfo info -only StatusLabel `lsappinfo find LSDisplayName=Slack`)
COUNT=${SLACK_INFO:25:1}

FONT="FantasqueSansM Nerd Font:Bold:18.0"
FONT="FantasqueSansM Nerd Font:Bold:22.0"
BGCOLOR=0x540b0b0b
COLOR=0xffa5a5a5
if [ $COUNT = "\"" ]; then
  COUNT=0
elif [ $COUNT = "•" ]; then
	COLOR=0xff00ff5d
else
	COLOR=0xffff0093
fi

sketchybar --set slack \
  icon= \
	drawing=on \
  icon.drawing=on \
	label="${COUNT}" \
  icon.font="${FONT}" \
  label.font="${FONT}" \
	icon.color="${COLOR}" \
  label.color="${COLOR}" \
  icon.padding_left=10 \
  icon.padding_right=0 \
  background.color="${BGCOLOR}" \
  background.height=26 \
  background.corner_radius=10 \
  updates=on \
  update_freq=3
