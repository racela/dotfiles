#!/usr/bin/env bash
# Send audio to the TV while a Steam game is running on the TV's workspace,
# and back to the desk speakers once it closes. Called from the window hooks
# in hyprland.lua.
#
# Only reverts audio it switched itself (tracked by a marker file), so a manual
# TV toggle (SUPER+ALT+T) isn't undone when a game closes.
set -uo pipefail

TV_WORKSPACE=11
TV_SINK=alsa_output.pci-0000_07_00.1.hdmi-stereo
# Steam sets the window class of games it launches to steam_app_<appid>
GAME_CLASS=${GAME_CLASS:-^steam_app_}
MARKER="${XDG_RUNTIME_DIR:-/tmp}/game-tv-audio"
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

# Events come in bursts (open/class/move); queue them so the last one wins.
exec 9>"${MARKER}.lock"
flock -w 15 9 || exit 0

sleep 1  # window class isn't always set the instant the window opens

games=$(hyprctl clients -j | jq --argjson ws "$TV_WORKSPACE" --arg re "$GAME_CLASS" \
    '[.[] | select(.workspace.id == $ws and (.class | test($re)))] | length')

if [ "${games:-0}" -gt 0 ]; then
    if [ "$(pactl get-default-sink)" != "$TV_SINK" ]; then
        "$SCRIPT_DIR/toggle-tv-audio.sh" tv --no-focus
        # Only claim it if the switch actually happened (TV audio may be unavailable)
        [ "$(pactl get-default-sink)" = "$TV_SINK" ] && touch "$MARKER"
    fi
elif [ -e "$MARKER" ]; then
    rm -f "$MARKER"
    "$SCRIPT_DIR/toggle-tv-audio.sh" desk --no-focus
fi
