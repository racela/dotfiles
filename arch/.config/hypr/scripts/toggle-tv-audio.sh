#!/usr/bin/env bash
# Toggle between "TV mode" (focus + audio on the TV) and "desk mode" (focus +
# audio back on the Edifier speakers). The GA104 sound card can only drive one
# of these HDMI/DP outputs at a time, so switching requires flipping its ACP
# profile, not just the default sink.
#
# Which profile each display lands on depends on the GPU audio pin the driver
# assigned it. With both connected the desk monitor is extra1 and the TV is
# plain hdmi-stereo, but with the TV off/unplugged the desk monitor can come
# up on hdmi-stereo instead. WirePlumber never defaults to a profile whose port
# is unavailable, so only toggle to the TV when its profile is available, and
# otherwise use whichever profile is. Profiles are set through wpctl so
# WirePlumber's saved profile follows instead of restoring the old one.
set -euo pipefail

CARD=alsa_card.pci-0000_07_00.1
SINK_PREFIX=alsa_output.pci-0000_07_00.1
TV_PROFILE=output:hdmi-stereo
SPEAKER_PROFILE=output:hdmi-stereo-extra1
HOME_WORKSPACE=2
TV_WORKSPACE=11

dump=$(pw-dump)
dev=$(jq -r --arg c "$CARD" '.[] | select(.info.props["device.name"] == $c) | .id' <<<"$dump")
# Lines of "<index> <name>" for each available stereo output profile
available=$(jq -r --arg c "$CARD" '
    .[] | select(.info.props["device.name"] == $c) | .info.params.EnumProfile[]
    | select(.available == "yes" and (.name | test("^output:hdmi-stereo"))) | "\(.index) \(.name)"' <<<"$dump")
current_profile=$(pactl -f json list cards | jq -r --arg c "$CARD" '.[] | select(.name == $c) | .active_profile')

has_profile() { awk -v p="$1" '$2 == p {f=1} END {exit !f}' <<<"$available"; }

# Switch the card to $1 (profile name) and print its sink name
activate_profile() {
    local idx
    idx=$(awk -v p="$1" '$2 == p {print $1}' <<<"$available")
    [ -n "$idx" ] || return 1
    wpctl set-profile "$dev" "$idx"
    sleep 1
    echo "$SINK_PREFIX.${1#output:}"
}

move_streams_to() {
    local sink=$1
    for id in $(pactl list short sink-inputs | awk '{print $1}'); do
        pactl move-sink-input "$id" "$sink" 2>/dev/null || true
    done
}

# TV mode needs both profiles available (desk monitor on extra1, TV on
# hdmi-stereo); if not, there's no TV audio to go to, so fall back to desk mode
# on whichever profile the desk monitor actually has.
if [ "$current_profile" = "$TV_PROFILE" ] || ! has_profile "$TV_PROFILE" || ! has_profile "$SPEAKER_PROFILE"; then
    desk_profile=$SPEAKER_PROFILE
    has_profile "$desk_profile" || desk_profile=$(awk 'NR==1 {print $2}' <<<"$available")
    [ -n "$desk_profile" ] || exit 1
    sink=$(activate_profile "$desk_profile")
    pactl set-default-sink "$sink"
    move_streams_to "$sink"
    hyprctl repl "return hl.dispatch(hl.dsp.focus({workspace = $HOME_WORKSPACE}))" >/dev/null
else
    sink=$(activate_profile "$TV_PROFILE")
    pactl set-default-sink "$sink"
    move_streams_to "$sink"
    hyprctl repl "return hl.dispatch(hl.dsp.focus({workspace = $TV_WORKSPACE}))" >/dev/null
fi
