#!/usr/bin/env bash
# Waybar custom module: shows/toggles all lights in the Home Assistant
# "bedroom" area. Credentials live outside the dotfiles repo (this file is
# symlinked from a public git repo) in ~/.config/home-assistant/env, e.g.:
#   HA_URL="https://home-assistant.rafa.local"
#   HA_TOKEN="eyJ..."
#   HA_AREA_ID="bedroom"
#
# NOTE: light.toggle on an area toggles each light independently based on its
# own current state, not as a single unified group - if the lights are split
# (some on, some off), one press can flip them further apart rather than
# turning them all off/on together.
set -euo pipefail

ENV_FILE="$HOME/.config/home-assistant/env"

if [ ! -f "$ENV_FILE" ]; then
    echo '{"text":"","tooltip":"Missing '"$ENV_FILE"'","class":"off"}'
    exit 0
fi
# shellcheck source=/dev/null
source "$ENV_FILE"

api() {
    curl -s --max-time 3 -H "Authorization: Bearer $HA_TOKEN" -H "Content-Type: application/json" "$@"
}

template() {
    api -X POST "$HA_URL/api/template" -d "{\"template\": \"$1\"}"
}

if [ "${1:-}" = "toggle" ]; then
    api -X POST "$HA_URL/api/services/light/toggle" -d "{\"area_id\": \"$HA_AREA_ID\"}" >/dev/null
    # Zigbee bulbs + HA's registry take ~0.3-0.6s to settle after the call
    # returns, so the waybar refresh signal fired right after this would
    # otherwise read stale state. Wait it out before returning.
    sleep 1
    exit 0
fi

any_on=$(template "{{ area_entities(\\\"$HA_AREA_ID\\\") | select(\\\"match\\\", \\\"^light\\\\\\\\.\\\") | map(\\\"states\\\") | select(\\\"eq\\\",\\\"on\\\") | list | count > 0 }}")

if [ "$any_on" = "True" ]; then
    echo '{"text":"","class":"on","tooltip":"Bedroom lights: on (click to turn off)"}'
else
    echo '{"text":"","class":"off","tooltip":"Bedroom lights: off (click to turn on)"}'
fi
