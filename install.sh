#!/bin/sh
# ClipHistory installer (macOS 11+, Intel and Apple silicon).
#   curl -fsSL https://raw.githubusercontent.com/chantanawat/ClipHistory/main/install.sh | sh
# Optional: ./install.sh /path/to/ClipHistory.zip   (use a zip you already downloaded)
set -eu

REPO="chantanawat/ClipHistory"
BASE="https://github.com/$REPO/releases/latest/download"
APP_NAME="ClipHistory.app"

say() { printf '%s\n' "$*"; }
die() { printf 'Error: %s\n' "$*" >&2; exit 1; }

[ "$(uname -s)" = "Darwin" ] || die "macOS only"
MAJOR="$(sw_vers -productVersion | cut -d. -f1)"
MINOR="$(sw_vers -productVersion | cut -d. -f2)"
if [ "$MAJOR" -eq 10 ] || { [ "$MAJOR" -lt 11 ] && [ "$MAJOR" -ne 10 ]; }; then
  die "ClipHistory needs macOS 11 (Big Sur) or newer (found $MAJOR.$MINOR)"
fi

WORK="$(mktemp -d "${TMPDIR:-/tmp}/cliphistory-install.XXXXXX")"
trap 'rm -rf "$WORK"' EXIT

if [ "${1:-}" ]; then
  [ -f "$1" ] || die "zip not found: $1"
  cp "$1" "$WORK/ClipHistory.zip"
else
  say "Downloading ClipHistory..."
  curl -fsSL "$BASE/ClipHistory.zip" -o "$WORK/ClipHistory.zip" || die "download failed"
  if curl -fsSL "$BASE/ClipHistory.zip.sha256" -o "$WORK/ClipHistory.zip.sha256" 2>/dev/null; then
    EXPECTED="$(awk '{print $1}' "$WORK/ClipHistory.zip.sha256")"
    ACTUAL="$(shasum -a 256 "$WORK/ClipHistory.zip" | awk '{print $1}')"
    [ "$EXPECTED" = "$ACTUAL" ] || die "checksum mismatch - download corrupted"
  fi
fi

ditto -x -k "$WORK/ClipHistory.zip" "$WORK/out"
[ -d "$WORK/out/$APP_NAME" ] || die "zip does not contain $APP_NAME"

if [ -w /Applications ]; then
  DEST="/Applications"
else
  DEST="$HOME/Applications"
  mkdir -p "$DEST"
fi

pkill -x ClipHistory 2>/dev/null || true
sleep 1
rm -rf "$DEST/$APP_NAME"
ditto "$WORK/out/$APP_NAME" "$DEST/$APP_NAME"
# The app is ad-hoc signed (no paid Apple developer account), so drop the download quarantine flag.
xattr -dr com.apple.quarantine "$DEST/$APP_NAME" 2>/dev/null || true

say "Installed to $DEST/$APP_NAME"
open "$DEST/$APP_NAME"
cat <<MSG

Done. ClipHistory is in your menu bar (the square icon). Open history with Command+Shift+V.
First paste: macOS asks for Accessibility permission. Turn ClipHistory on in
System Settings > Privacy & Security > Accessibility (after every update you may need to do it again).
MSG
