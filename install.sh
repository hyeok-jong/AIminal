#!/bin/bash
# Initia installer
#   curl -fsSL https://raw.githubusercontent.com/hyeok-jong/Initia/beta/install.sh | bash
set -euo pipefail

REPO="hyeok-jong/Initia"
APP_NAME="Initia.app"

bold() { printf "\033[1m%s\033[0m\n" "$1"; }
fail() { printf "\033[31mError:\033[0m %s\n" "$1" >&2; exit 1; }

[[ "$(uname)" == "Darwin" ]] || fail "Initia only runs on macOS."
MAJOR=$(sw_vers -productVersion | cut -d. -f1)
(( MAJOR >= 15 )) || fail "Initia requires macOS 15 or later (you have $(sw_vers -productVersion))."

# INITIA_URL / INITIA_DEST_DIR 로 다운로드 주소와 설치 위치를 바꿀 수 있음
URL="${INITIA_URL:-}"
if [[ -z "$URL" ]]; then
bold "==> Finding the latest Initia release"
# 베타 릴리스(prerelease)도 포함해서 가장 최신 것을 고름
URL=$(curl -fsSL "https://api.github.com/repos/$REPO/releases" \
    | grep -o '"browser_download_url": *"[^"]*\.zip"' \
    | head -n 1 | sed -E 's/.*"(https[^"]+)"/\1/')
[[ -n "$URL" ]] || fail "No release found at https://github.com/$REPO/releases"
fi
echo "    $URL"

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

bold "==> Downloading"
curl -fsSL "$URL" -o "$TMP/Initia.zip"

# 체크섬 파일이 있으면 검증
if curl -fsSL "$URL.sha256" -o "$TMP/Initia.zip.sha256" 2>/dev/null; then
    EXPECTED=$(awk '{print $1}' "$TMP/Initia.zip.sha256")
    ACTUAL=$(shasum -a 256 "$TMP/Initia.zip" | awk '{print $1}')
    [[ "$EXPECTED" == "$ACTUAL" ]] || fail "Checksum mismatch."
    echo "    checksum OK"
fi

ditto -x -k "$TMP/Initia.zip" "$TMP"
[[ -d "$TMP/$APP_NAME" ]] || fail "The archive does not contain $APP_NAME."

# /Applications에 쓸 수 있으면 거기, 아니면 ~/Applications
if [[ -n "${INITIA_DEST_DIR:-}" ]]; then DEST_DIR="$INITIA_DEST_DIR"
elif [[ -w /Applications ]]; then DEST_DIR=/Applications; else DEST_DIR="$HOME/Applications"; fi
mkdir -p "$DEST_DIR"
DEST="$DEST_DIR/$APP_NAME"

bold "==> Installing to $DEST"
pkill -x Initia 2>/dev/null || true
rm -rf "$DEST"
ditto "$TMP/$APP_NAME" "$DEST"
xattr -dr com.apple.quarantine "$DEST" 2>/dev/null || true

if ! command -v tmux >/dev/null 2>&1 && [[ ! -x /opt/homebrew/bin/tmux && ! -x /usr/local/bin/tmux ]]; then
    printf "\n\033[33mNote:\033[0m tmux is not installed. Install it with: brew install tmux\n"
fi

[[ -n "${INITIA_NO_OPEN:-}" ]] || open "$DEST"
bold "==> Done! Initia is in your menu bar and Dock."
