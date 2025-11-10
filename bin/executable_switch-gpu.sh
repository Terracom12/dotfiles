#!/usr/bin/env bash

#
# Switch GPU between integrated/hybrid/dedicated via supergfxctl
#

# BUG: ? "Supported" modes change depending on how GPU mode is set
# readarray -td ' ' supported_modes < <(supergfxctl --supported | cut -c2- | rev | cut -c2- | rev | sed 's/,//g')
supported_modes=(Integrated Hybrid AsusMuxDgpu)
current_mode="$(supergfxctl --get)"

# add first elem to the end to support simple wrap-around
supported_modes+=("${supported_modes[0]}")

next_mode=

for i in "${!supported_modes[@]}"; do
    if [[ ${supported_modes[i]} == "$current_mode" ]]; then
        next_mode="${supported_modes[$((i + 1))]}"
        break
    fi
done

if ! [[ $next_mode ]]; then
    echo 'Error switching GPU mode'
    exit 1
fi

echo "Switching to GPU mode : $next_mode"
supergfxctl --mode "$next_mode"
