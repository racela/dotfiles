#!/usr/bin/env bash
set -euo pipefail
ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
command -v git >/dev/null || { echo 'git is required.' >&2; exit 1; }
while read -r relative url revision; do
    [[ -z "$relative" || "$relative" = \#* ]] && continue
    destination="$HOME/$relative"
    if [ -e "$destination" ] || [ -L "$destination" ]; then
        actual=$(git -C "$destination" rev-parse HEAD 2>/dev/null || true)
        if [ "$actual" != "$revision" ]; then
            printf 'Keeping existing %s (differs from plugins.lock).\n' "$destination"
        fi
        continue
    fi
    mkdir -p "$(dirname "$destination")"
    # Clone to a temporary sibling so interrupted downloads are safe to retry.
    staging=$(mktemp -d "${destination}.bootstrap.XXXXXX")
    trap 'rm -rf -- "$staging"' EXIT
    git clone --no-checkout "$url" "$staging"
    git -C "$staging" checkout --detach "$revision"
    mv -- "$staging" "$destination"
    trap - EXIT
done < "$ROOT/plugins.lock"
