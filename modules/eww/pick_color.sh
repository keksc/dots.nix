#!/usr/bin/env bash

# Get normalized RGB and convert to 0-255 integers
read r g b < <(niri msg -j pick-color \
    | jq -r '.rgb | map((. * 255) | floor) | @tsv')

# Convert to hex
hex=$(printf '#%02x%02x%02x' "$r" "$g" "$b")

# Copy to clipboard
echo -n "$hex" | wl-copy
