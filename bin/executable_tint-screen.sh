#!/usr/bin/env bash

#
# Tint the screen the color specified, or red by default
#

if [[ $# -eq 0 ]]; then
    # red tint
    color='4.2:1.5:1'
elif [[ $1 == off ]]; then
    color='1:1:1'
elif [[ $1 =~ [0-9.]+:[0-9.]+:[0-9.]+ ]]; then
    color="$1"
else
    echo "Bad argument. Must be 'off' or 3 float vals seperated by ':' (e.g. 1.5:2.3:0.7)"
    exit 1
fi

# I really hope this output is stable
# output="$(xrandr --listmonitors | tail -n1 | awk '{ print $NF }')"
# FIXME: Monitor is hardcoded for now because xrandr querying is slow as hell for some reason
output='eDP-1'

xrandr --output "$output" --gamma "$color"
