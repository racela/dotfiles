#!/usr/bin/env bash
# Toggle between "TV mode" (focus + audio on the TV) and "desk mode" (focus +
# audio back on the Edifier speakers). The GA104 sound card can only drive one
# of these HDMI/DP outputs at a time, so switching requires flipping its ACP
# profile, not just the default sink.
set -euo pipefail

CARD=alsa_card.pci-0000_07_00.1
TV_PROFILE=output:hdmi-stereo
SPEAKER_PROFILE=output:hdmi-stereo-extra1
TV_SINK=alsa_output.pci-0000_07_00.1.hdmi-stereo
SPEAKER_SINK=alsa_output.pci-0000_07_00.1.hdmi-stereo-extra1
HOME_WORKSPACE=2
TV_WORKSPACE=11

current_profile=$(pactl -f json list cards | jq -r --arg c "$CARD" '.[] | select(.name == $c) | .active_profile')

move_streams_to() {
    local sink=$1
    for id in $(pactl list short sink-inputs | awk '{print $1}'); do
        pactl move-sink-input "$id" "$sink" 2>/dev/null || true
    done
}

if [ "$current_profile" = "$TV_PROFILE" ]; then
    pactl set-card-profile "$CARD" "$SPEAKER_PROFILE"
    pactl set-default-sink "$SPEAKER_SINK"
    move_streams_to "$SPEAKER_SINK"
    hyprctl repl "return hl.dispatch(hl.dsp.focus({workspace = $HOME_WORKSPACE}))" >/dev/null
else
    pactl set-card-profile "$CARD" "$TV_PROFILE"
    pactl set-default-sink "$TV_SINK"
    move_streams_to "$TV_SINK"
    hyprctl repl "return hl.dispatch(hl.dsp.focus({workspace = $TV_WORKSPACE}))" >/dev/null
fi
