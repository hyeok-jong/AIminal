#!/bin/bash
# AIminal installer (spelled Aiminal in 0.11; formerly Termoor, and Initia before that)
#   curl -fsSL https://raw.githubusercontent.com/hyeok-jong/AIminal/beta/install.sh | bash
set -euo pipefail

# Everything runs inside main(), called on the last line: if the download of this script is cut off
# halfway through `curl | bash`, bash never reaches the call and nothing is half-executed.
main() {
REPO="hyeok-jong/AIminal"
APP_NAME="AIminal.app"
BUNDLE_ID="com.hyeokjong.initia"

bold() { printf "\033[1m%s\033[0m\n" "$1"; }
fail() { printf "\033[31mError:\033[0m %s\n" "$1" >&2; exit 1; }

[[ "$(uname)" == "Darwin" ]] || fail "AIminal only runs on macOS."
MAJOR=$(sw_vers -productVersion | cut -d. -f1)
(( MAJOR >= 15 )) || fail "AIminal requires macOS 15 or later (you have $(sw_vers -productVersion))."

# AIMINAL_URL / AIMINAL_DEST_DIR / AIMINAL_NO_OPEN (old TERMOOR_* and INITIA_* names still work)
URL="${AIMINAL_URL:-${TERMOOR_URL:-${INITIA_URL:-}}}"
if [[ -z "$URL" ]]; then
bold "==> Finding the latest AIminal release"
# Includes beta (prerelease) builds. Each release also carries Termoor-*.zip and 0-Initia-*.zip for older updaters; skip those.
# The grep is case-insensitive so a release spelled Aiminal-*.zip (0.11) would also match.
# Fetch the list first, then search it: if grep/head closed the pipe early, curl would die with "Failure writing output" under pipefail
RELEASES=$(curl -fsSL "https://api.github.com/repos/$REPO/releases") \
    || fail "Couldn't get the release list from api.github.com. If you're offline, reconnect; if many people share your network, GitHub may be rate-limiting it — try again in an hour, or download the zip from https://github.com/$REPO/releases"
URL=$(printf '%s' "$RELEASES" \
    | grep -m1 -io '"browser_download_url": *"[^"]*/AIminal-[^"]*\.zip"' \
    | sed -E 's/.*"(https[^"]+)"/\1/' || true)
[[ -n "$URL" ]] || fail "No release found at https://github.com/$REPO/releases"
fi
echo "    $URL"

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

bold "==> Downloading"
curl -fsSL "$URL" -o "$TMP/AIminal.zip"

# Verify the checksum. Every release ships a .sha256 next to the zip; refuse to install without it (same rule as the in-app updater)
curl -fsSL "$URL.sha256" -o "$TMP/AIminal.zip.sha256" 2>/dev/null || fail "No checksum file for $URL"
EXPECTED=$(awk '{print $1}' "$TMP/AIminal.zip.sha256")
ACTUAL=$(shasum -a 256 "$TMP/AIminal.zip" | awk '{print $1}')
[[ "$EXPECTED" == "$ACTUAL" ]] || fail "Checksum mismatch."
echo "    checksum OK"

ditto -x -k "$TMP/AIminal.zip" "$TMP"
[[ -d "$TMP/$APP_NAME" ]] || fail "The archive does not contain $APP_NAME."

# Where to install: an explicit AIMINAL_DEST_DIR, else wherever AIminal (or an older name) already is —
# so an update never leaves a second copy with the Dock and login item still pointing at the old one —
# else /Applications if writable, otherwise ~/Applications.
DEST_DIR="${AIMINAL_DEST_DIR:-${TERMOOR_DEST_DIR:-${INITIA_DEST_DIR:-}}}"
if [[ -z "$DEST_DIR" ]]; then
    for D in "$HOME/Applications" /Applications; do
        for N in AIminal Termoor Initia; do
            if [[ -z "$DEST_DIR" && -d "$D/$N.app" && -w "$D" ]]; then DEST_DIR="$D"; fi
        done
    done
fi
if [[ -z "$DEST_DIR" ]]; then
    if [[ -w /Applications ]]; then DEST_DIR=/Applications; else DEST_DIR="$HOME/Applications"; fi
fi
mkdir -p "$DEST_DIR"
DEST="$DEST_DIR/$APP_NAME"

bold "==> Installing to $DEST"
# Copy the new app next to the destination first; the old one is only removed once the copy is complete.
STAGED="$DEST_DIR/.AIminal.installing.app"
rm -rf "$STAGED"
ditto "$TMP/$APP_NAME" "$STAGED" || { rm -rf "$STAGED"; fail "Couldn't copy the app to $DEST_DIR."; }
xattr -dr com.apple.quarantine "$STAGED" 2>/dev/null || true

# Ask a running AIminal to quit normally (it offers to save unsaved editor files), then make sure it is gone.
# tmux sessions keep running either way.
if pgrep -x AIminal >/dev/null || pgrep -x Aiminal >/dev/null; then
    osascript -e "tell application id \"$BUNDLE_ID\" to quit" >/dev/null 2>&1 || true
    for _ in $(seq 1 50); do pgrep -x AIminal >/dev/null || pgrep -x Aiminal >/dev/null || break; sleep 0.2; done
fi
for P in AIminal Aiminal Termoor Initia; do pkill -x "$P" 2>/dev/null || true; done
# pkill only sends the signal; wait (up to 5 s) for the old app to actually exit before replacing its bundle
for _ in $(seq 1 25); do
    pgrep -x AIminal >/dev/null || pgrep -x Aiminal >/dev/null || pgrep -x Termoor >/dev/null || pgrep -x Initia >/dev/null || break
    sleep 0.2
done

rm -rf "$DEST"
mv "$STAGED" "$DEST" || fail "Couldn't move the app into place. The new copy is at $STAGED"
# AIminal was spelled Aiminal (0.11) and called Termoor (0.10) and Initia (before 0.10). Remove the old app next to it
# (settings carry over). On a case-insensitive volume "Aiminal.app" is the app we just installed, so compare with -ef, not by name.
for OLD in Aiminal Termoor Initia; do
    if [[ -d "$DEST_DIR/$OLD.app" && ! "$DEST_DIR/$OLD.app" -ef "$DEST" ]]; then
        rm -rf "$DEST_DIR/$OLD.app"
        echo "    removed the old $OLD.app (your settings carry over)"
    fi
done

if ! command -v tmux >/dev/null 2>&1 && [[ ! -x /opt/homebrew/bin/tmux && ! -x /usr/local/bin/tmux ]]; then
    printf "\n\033[33mNote:\033[0m tmux is not installed. Install it with: brew install tmux\n"
fi

[[ -n "${AIMINAL_NO_OPEN:-${TERMOOR_NO_OPEN:-${INITIA_NO_OPEN:-}}}" ]] || open "$DEST"
bold "==> Done! AIminal is in your menu bar and Dock."
}

main "$@"
