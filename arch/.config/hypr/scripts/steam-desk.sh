#!/usr/bin/env bash
# Launch Steam on the desk monitor instead of the TV. By default every Steam
# window is pinned to the TV's workspace by the "steam-on-tv" window rule in
# hyprland.lua; this switches that rule off, puts Steam on the desk, and turns
# the rule back on once Steam exits so the next plain launch goes to the TV.
#
# Usage: steam-desk.sh [workspace]   (default 4)
set -euo pipefail

WORKSPACE=${1:-4}

repl() { hyprctl repl "$1" >/dev/null; }

repl "steam_tv_rule:set_enabled(false)"

if pgrep -x steam >/dev/null; then
    # Already running (e.g. started on the TV at login): bring its windows over.
    repl "for _, w in ipairs(hl.get_windows({ class = 'steam' })) do hl.dispatch(hl.dsp.window.move({ workspace = $WORKSPACE, window = w, follow = false })) end"
    repl "hl.dispatch(hl.dsp.focus({ workspace = $WORKSPACE }))"
else
    repl "hl.exec_cmd('steam', { workspace = '$WORKSPACE' })"
fi

# Restore the TV rule after Steam quits.
(
    sleep 5
    while pgrep -x steam >/dev/null; do sleep 5; done
    repl "steam_tv_rule:set_enabled(true)"
) >/dev/null 2>&1 &
disown
