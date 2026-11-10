#!/bin/bash
# Aiminal installer (formerly Termoor, and Initia before that)
#   curl -fsSL https://raw.githubusercontent.com/hyeok-jong/Aiminal/beta/install.sh | bash
set -euo pipefail

REPO="hyeok-jong/Aiminal"
APP_NAME="Aiminal.app"

bold() { printf "\033[1m%s\033[0m\n" "$1"; }
fail() { printf "\033[31mError:\033[0m %s\n" "$1" >&2; exit 1; }

[[ "$(uname)" == "Darwin" ]] || fail "Aiminal only runs on macOS."
MAJOR=$(sw_vers -productVersion | cut -d. -f1)
(( MAJOR >= 15 )) || fail "Aiminal requires macOS 15 or later (you have $(sw_vers -productVersion))."

# AIMINAL_URL / AIMINAL_DEST_DIR / AIMINAL_NO_OPEN (old TERMOOR_* and INITIA_* names still work)
URL="${AIMINAL_URL:-${TERMOOR_URL:-${INITIA_URL:-}}}"
if [[ -z "$URL" ]]; then
bold "==> Finding the latest Aiminal release"
# Includes beta (prerelease) builds. Each release also carries Termoor-*.zip and 0-Initia-*.zip for older updaters; skip those.
URL=$(curl -fsSL "https://api.github.com/repos/$REPO/releases" \
    | grep -o '"browser_download_url": *"[^"]*/Aiminal-[^"]*\.zip"' \
    | head -n 1 | sed -E 's/.*"(https[^"]+)"/\1/')
[[ -n "$URL" ]] || fail "No release found at https://github.com/$REPO/releases"
fi
echo "    $URL"

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

bold "==> Downloading"
curl -fsSL "$URL" -o "$TMP/Aiminal.zip"

# Verify the checksum when the release has one
if curl -fsSL "$URL.sha256" -o "$TMP/Aiminal.zip.sha256" 2>/dev/null; then
    EXPECTED=$(awk '{print $1}' "$TMP/Aiminal.zip.sha256")
    ACTUAL=$(shasum -a 256 "$TMP/Aiminal.zip" | awk '{print $1}')
    [[ "$EXPECTED" == "$ACTUAL" ]] || fail "Checksum mismatch."
    echo "    checksum OK"
fi

ditto -x -k "$TMP/Aiminal.zip" "$TMP"
[[ -d "$TMP/$APP_NAME" ]] || fail "The archive does not contain $APP_NAME."

# /Applications if writable, otherwise ~/Applications
DEST_DIR="${AIMINAL_DEST_DIR:-${TERMOOR_DEST_DIR:-${INITIA_DEST_DIR:-}}}"
if [[ -z "$DEST_DIR" ]]; then
    if [[ -w /Applications ]]; then DEST_DIR=/Applications; else DEST_DIR="$HOME/Applications"; fi
fi
mkdir -p "$DEST_DIR"
DEST="$DEST_DIR/$APP_NAME"

bold "==> Installing to $DEST"
pkill -x Aiminal 2>/dev/null || true
pkill -x Termoor 2>/dev/null || true
pkill -x Initia 2>/dev/null || true
rm -rf "$DEST"
ditto "$TMP/$APP_NAME" "$DEST"
xattr -dr com.apple.quarantine "$DEST" 2>/dev/null || true
# Aiminal was called Termoor (0.10) and Initia (before 0.10). Remove the old app next to it (settings carry over).
for OLD in Termoor Initia; do
    if [[ -d "$DEST_DIR/$OLD.app" ]]; then
        rm -rf "$DEST_DIR/$OLD.app"
        echo "    removed the old $OLD.app (your settings carry over)"
    fi
done

if ! command -v tmux >/dev/null 2>&1 && [[ ! -x /opt/homebrew/bin/tmux && ! -x /usr/local/bin/tmux ]]; then
    printf "\n\033[33mNote:\033[0m tmux is not installed. Install it with: brew install tmux\n"
fi

[[ -n "${AIMINAL_NO_OPEN:-${TERMOOR_NO_OPEN:-${INITIA_NO_OPEN:-}}}" ]] || open "$DEST"
bold "==> Done! Aiminal is in your menu bar and Dock."
