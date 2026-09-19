#!/usr/bin/env bash
# Waybar custom module: shows/toggles default audio output between the
# Edifier speakers (desk monitor's DP audio-out) and the HyperX headset.
#
# NOTE: the GA104 sound card can only drive one HDMI/DP output profile at a
# time (see toggle-tv-audio.sh) - switching to speakers re-asserts that
# profile in case the TV toggle left it pointed at the TV instead.
#
# Which profile the desk monitor lands on depends on which GPU audio pin the
# driver assigned it, and that shifts (e.g. when the TV is off/unplugged the
# monitor can come up on plain hdmi-stereo). A profile whose port is
# unavailable is never chosen as default by WirePlumber, so pick whichever
# profile is actually available, preferring the usual one.
set -euo pipefail

SPEAKER_CARD=alsa_card.pci-0000_07_00.1
SPEAKER_PROFILE_PREFERRED=output:hdmi-stereo-extra1
HEADSET_SINK=alsa_output.usb-Kingston_HyperX_Virtual_Surround_Sound_00000000-00.analog-stereo

move_streams_to() {
    local sink=$1
    for id in $(pactl list short sink-inputs | awk '{print $1}'); do
        pactl move-sink-input "$id" "$sink" 2>/dev/null || true
    done
}

# Set the card profile through WirePlumber (not pactl) so its saved profile
# follows, otherwise it restores the old one; echoes the resulting sink name.
activate_speaker_profile() {
    local dump dev profiles idx name
    dump=$(pw-dump)
    dev=$(jq -r --arg c "$SPEAKER_CARD" '.[] | select(.info.props["device.name"] == $c) | .id' <<<"$dump")
    profiles=$(jq -r --arg c "$SPEAKER_CARD" '
        .[] | select(.info.props["device.name"] == $c) | .info.params.EnumProfile[]
        | select(.available == "yes" and (.name | test("^output:hdmi-stereo"))) | "\(.index) \(.name)"' <<<"$dump")
    read -r idx name < <(grep -F " $SPEAKER_PROFILE_PREFERRED" <<<"$profiles" || head -n1 <<<"$profiles")
    [ -n "${idx:-}" ] || return 1
    wpctl set-profile "$dev" "$idx"
    sleep 1
    echo "alsa_output.pci-0000_07_00.1.${name#output:}"
}

current=$(pactl get-default-sink)

if [ "${1:-}" = "toggle" ]; then
    if [ "$current" = "$HEADSET_SINK" ]; then
        SPEAKER_SINK=$(activate_speaker_profile) || exit 1
        pactl set-default-sink "$SPEAKER_SINK"
        move_streams_to "$SPEAKER_SINK"
    else
        pactl set-default-sink "$HEADSET_SINK"
        move_streams_to "$HEADSET_SINK"
    fi
    exit 0
fi

if [ "$current" = "$HEADSET_SINK" ]; then
    echo '{"text":"","class":"headset","tooltip":"Audio: headset (click to switch to speakers)"}'
else
    echo '{"text":"󰓃","class":"speakers","tooltip":"Audio: speakers (click to switch to headset)"}'
fi
