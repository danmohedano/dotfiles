#!/usr/bin/env bash

# Sleep to ensure that polybar has finished before executing pywal
sleep 3

# Regenerate last colorscheme (necessary for polybar to get the colors)
wal -R

# Set the wallpaper using feh. Even though wal already sets the wallpaper,
# this is necessary to ensure that the transparecy of pywal works correctly
feh --bg-scale ~/Pictures/wallpaper.png
