#!/usr/bin/env bash
# Waybar custom module: shows/toggles default audio output between the
# Edifier speakers (desk monitor's DP audio-out) and the HyperX headset.
#
# NOTE: the GA104 sound card can only drive one HDMI/DP output profile at a
# time (see toggle-tv-audio.sh) - switching to speakers re-asserts that
# profile in case the TV toggle left it pointed at the TV instead.
set -euo pipefail

SPEAKER_SINK=alsa_output.pci-0000_07_00.1.hdmi-stereo-extra1
SPEAKER_CARD=alsa_card.pci-0000_07_00.1
SPEAKER_PROFILE=output:hdmi-stereo-extra1
HEADSET_SINK=alsa_output.usb-Kingston_HyperX_Virtual_Surround_Sound_00000000-00.analog-stereo

move_streams_to() {
    local sink=$1
    for id in $(pactl list short sink-inputs | awk '{print $1}'); do
        pactl move-sink-input "$id" "$sink" 2>/dev/null || true
    done
}

current=$(pactl get-default-sink)

if [ "${1:-}" = "toggle" ]; then
    if [ "$current" = "$HEADSET_SINK" ]; then
        pactl set-card-profile "$SPEAKER_CARD" "$SPEAKER_PROFILE"
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
