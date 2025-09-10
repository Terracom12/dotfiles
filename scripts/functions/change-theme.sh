#!/usr/bin/env bash

# Copyright (c) 2025 Matthew Reese. All Rights Reserved.

DIR=$(dirname "${BASH_SOURCE[0]}")

source "${DIR}"/../_utils.sh

# TODO: Probably want to implement for other terminals
if ! command -v ghostty &>/dev/null; then
    reterr 1 "ghostty is not an executable"
fi

# Primary script interface
# Call with no arguments to switch to the default theme specified in your config
# Call with one argument naming a theme to switch to that theme
#   See also: `ghostty +list-themes` for a list of theme names
function change_theme() {
    # Raw theme directives that would appear in a ghostty config
    local theme_directives=

    # Simplified invokation where the user doesn't need to put quotes for multi-word themes
    local theme_name="$*"

    if [[ -z $theme_name ]]; then
        # Switch to default theme, which is parsed as by combining the default config with the user specified one
        # Special handling is also done for any theme specifications in the user config

        # Default config directives
        theme_directives+=$(ghostty +show-config --default)
        # User set config directives
        theme_directives+=$(ghostty +show-config --changes-only)

        if user_theme_directive=$(grep -qE '^theme =\s+\w+') && [[ -n $user_theme_directive ]]; then
            if user_theme_name=$(cut -d '=' -f 2 | cut -c 2-); then
                theme_name=$(awk '{$1=$1};1' <<<"$user_theme_name")
                debugmsg "Using theme '$theme_name' from user config"
            else
                err "Bad theme name spec in user config"
                return 1
            fi <<<"$user_theme_directive"
        fi <<<"$theme_directives"
    fi

    # Not `else` as theme name could be set in user config
    if [[ -n $theme_name ]]; then
        if ! ret=$(_load_theme "$theme_name"); then
            err "$ret"
            return 2
        else
            theme_directives+="$ret"
        fi
    fi

    debugmsg "loaded config directives" "$theme_directives"

    local -r escapes="$(_theme_directives_to_escs "$theme_directives")"
    debugmsg "escape sequences:" "$escapes"

    echo -en "$escapes"
}

# Usage: _load_theme <theme-name>
# Returns: ghostty config directives for the given theme
function _load_theme() {
    if [[ $# -ne 1 ]]; then
        err "bad _load_theme call"
        return 1
    fi

    local -r theme_name="$1"
    # In order:
    #   Get a list of all themes
    #     Looks like: "zenwritten_light (resources) /usr/share/ghostty/themes/zenwritten_light"
    #   Find the one we're looking for -- case insesitively
    #   Discard all but the first match
    #   reverse the line (so cut is easier)
    #   cut until the first parenthesis
    #   reverse the line back to normal
    #   remove the leading space character
    local -r theme_path=$(ghostty +list-themes --path --plain |
        grep -i "$theme_name" |
        head -n1 |
        rev |
        cut -d ')' -f '1' |
        rev |
        cut -c '2-')

    if [[ -z $theme_path ]]; then
        err "bad theme name"
        return 2
    fi

    cat "$theme_path"
}

# Change ghostty theme config directives to OSC escape codes
# Usage:
#   _theme_directives_to_escs <directives>
#
#   where <directives> is a linefeed-seperated list of ghostty config directives
function _theme_directives_to_escs() {
    if [[ $# -ne 1 ]]; then
        err "bad _theme_directives_to_escs call"
        return 1
    fi

    local output

    local -r config_text="$1"

    # Only use the last directives for foreground and background
    local -r foreground=$(_get_directive_value "$config_text" foreground | tail -n1)
    local -r background=$(_get_directive_value "$config_text" background | tail -n1)
    local -r cursor_color=$(_get_directive_value "$config_text" 'cursor-color' | tail -n1)

    local -r palettes=$(_get_directive_value "$config_text" palette)

    debugmsg "fg=$foreground" "bg = $background" "palettes= $palettes"

    # Credit to the following for OSC guide
    # https://github.com/ghostty-org/ghostty/discussions/3457#discussioncomment-12106873
    #
    # \e]10;  - foreground
    # \e]11;  - background
    # \e]4;   - palettes (multiple at once is fine)
    # \e]12;  - cursor color

    if [[ $foreground ]]; then
        output+="\e]10;$foreground\a"
    fi
    if [[ $background ]]; then
        output+="\e]11;$background\a"
    fi
    if [[ $cursor_color ]]; then
        output+="\e]12;$cursor_color\a"
    fi

    if [[ $palettes ]]; then
        output+="\e]4;"
    fi

    for palette in $palettes; do
        if [[ $palette ]]; then
            output+="${palette/=/;};"
        fi
    done

    if [[ $palettes ]]; then
        # Stip final trailing ';' and add '\a'
        output="${output::-1}\a"
    fi

    echo -n "$output"
}

# Get the value(s) of all ghostty config directives with matching keys
# Usage:
#    _get_directive_values <config-text> <directive-name>
# Returns:
#   Space-separated list of values
function _get_directive_value() {
    if [[ $# -ne 2 ]]; then
        err "bad _get_directive_value call; expected 2 params, got $#"
        return 1
    fi

    local -r config_text="$1"
    local -r directive_name="$2"

    # Find matching lines
    # Get value of key-value '='-separated pair
    # Strip leading and trailing spaces (cred. https://unix.stackexchange.com/a/205854)
    grep -E "^$directive_name =\s+\S+" <<<"$config_text" |
        cut -d '=' -f 2- |
        awk '{$1=$1};1'
}
