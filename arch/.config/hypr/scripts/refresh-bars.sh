#!/usr/bin/env bash
# Reload waybar and restart hyprpaper after a monitor is plugged/unplugged.
#
# When the TV (HDMI-A-1) is hot-plugged, the NVIDIA modeset races with the
# desk monitor's compositor commits and the layer-shell surfaces on DP-1 go
# stale: the bar and wallpaper stop being painted even though Hyprland still
# lists them (and keeps reserving space for the bar). Recreating both clients
# once the modeset has settled fixes it. Called from the monitor.added /
# monitor.removed hooks in hyprland.lua.
set -uo pipefail

# Several events fire per hotplug; only let one run at a time.
exec 9>"${XDG_RUNTIME_DIR:-/tmp}/refresh-bars.lock"
flock -n 9 || exit 0

sleep 2
pkill -SIGUSR2 -x waybar
pkill -x hyprpaper
sleep 0.5
# 9>&- so hyprpaper doesn't inherit (and forever hold) the lock
setsid hyprpaper 9>&- >/dev/null 2>&1 &
sleep 1
