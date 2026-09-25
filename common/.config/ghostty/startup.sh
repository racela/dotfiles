#!/usr/bin/env bash
# Reuse one session, and leave a shell open after detaching.
if command -v tmux >/dev/null 2>&1 && [ -z "${TMUX:-}" ]; then
    tmux new-session -A -s ghostty
fi
exec "${SHELL:-/bin/sh}"
