#!/usr/bin/env bash

wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)}'
alsactl monitor | grep --color=never --line-buffered "Master Playback Volume" | while IFS= read -r line; do wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)}'; done
