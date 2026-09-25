#!/usr/bin/env bash
# Run as your normal user; only package installation uses sudo.
set -euo pipefail
ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
packages=1 plugins=1 desktop=0 dry_run=0 unlink=0
usage() {
    cat <<'HELP'
Usage: ./bootstrap.sh [options]
  --desktop        Also install/link the personal Arch Hyprland desktop
  --skip-packages   Only configure tools already installed
  --skip-plugins    Skip pinned Zsh/tmux plugin downloads
  --dry-run        Print commands without changing anything
  --unlink         Remove managed links; keep packages and plugin data
  -h, --help       Show this help
HELP
}
for arg in "$@"; do
    case "$arg" in
        --desktop) desktop=1 ;;
        --skip-packages) packages=0 ;;
        --skip-plugins) plugins=0 ;;
        --dry-run) dry_run=1 ;;
        --unlink) unlink=1; packages=0; plugins=0 ;;
        -h|--help) usage; exit 0 ;;
        *) printf 'Unknown option: %s\n' "$arg" >&2; usage >&2; exit 2 ;;
    esac
done
case "$(uname -s)" in
    Darwin) platform=mac ;;
    Linux)
        # shellcheck source=/dev/null
        . /etc/os-release
        [ "${ID:-}" = arch ] || { echo 'Only Arch Linux and macOS are supported.' >&2; exit 1; }
        platform=arch ;;
    *) echo 'Only Arch Linux and macOS are supported.' >&2; exit 1 ;;
esac
if [ "$desktop" = 1 ] && [ "$platform" != arch ]; then
    echo '--desktop is only supported on Arch Linux.' >&2; exit 2
fi
if [ "$EUID" = 0 ]; then
    echo 'Run this script as your normal user, without sudo.' >&2; exit 1
fi
if [ "${XDG_CONFIG_HOME:-$HOME/.config}" != "$HOME/.config" ]; then
    echo 'These Stow packages require XDG_CONFIG_HOME=$HOME/.config (or unset).' >&2; exit 1
fi
run() {
    printf '+'; printf ' %q' "$@"; printf '\n'
    if [ "$dry_run" = 0 ]; then "$@"; fi
}
if [ "$packages" = 1 ]; then
    if [ "$platform" = arch ]; then
        pkgs=()
        manifests=("$ROOT/pkglists/arch-core.txt")
        [ "$desktop" = 0 ] || manifests+=("$ROOT/pkglists/arch-desktop.txt")
        for manifest in "${manifests[@]}"; do
            while IFS= read -r pkg; do
                [[ -z "$pkg" || "$pkg" = \#* ]] || pkgs+=("$pkg")
            done < "$manifest"
        done
        # Upgrade as well as refresh: never create an Arch partial upgrade.
        run sudo pacman -Syu --needed "${pkgs[@]}"
    else
        if ! command -v brew >/dev/null 2>&1; then
            for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew; do
                if [ -x "$candidate" ]; then eval "$("$candidate" shellenv)"; break; fi
            done
        fi
        if ! command -v brew >/dev/null 2>&1 && [ "$dry_run" = 0 ]; then
            echo 'Install Homebrew from https://brew.sh, then rerun this script.' >&2; exit 1
        fi
        run brew bundle --file="$ROOT/Brewfile"
    fi
fi
if [ "$dry_run" = 0 ]; then
    command -v stow >/dev/null || { echo 'GNU Stow is required; install packages or install stow manually.' >&2; exit 1; }
fi
platform_flags=('--ignore=^\.config/(spicetify|nightTab)(/|$)')
[ "$desktop" = 1 ] || platform_flags+=('--ignore=^\.config$')
stow_base=(stow --dir="$ROOT" --target="$HOME" --no-folding)
if [ "$unlink" = 1 ]; then
    run "${stow_base[@]}" --delete common
    run "${stow_base[@]}" "${platform_flags[@]}" --delete "$platform"
    exit 0
fi
# Check both packages before linking either. Never adopt or overwrite user files.
run "${stow_base[@]}" --simulate --stow common
run "${stow_base[@]}" "${platform_flags[@]}" --simulate --stow "$platform"
if [ "$plugins" = 1 ]; then run bash "$ROOT/scripts/install-plugins.sh"; fi
run "${stow_base[@]}" --stow common
run "${stow_base[@]}" "${platform_flags[@]}" --stow "$platform"
if [ "$dry_run" = 1 ]; then
    echo 'Preview complete; no changes made.'
    exit 0
fi
echo 'Setup complete. Open a new Zsh shell and launch nvim to finish editor setup.'
echo 'See README.md for default-shell, desktop and machine-specific setup.'
