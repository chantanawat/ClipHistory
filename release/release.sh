#!/bin/sh
# Builds the universal app (ad-hoc signed) and packs dist/release/ClipHistory.zip + .sha256
# Run from anywhere. Upload both files to a GitHub Release (asset names must stay unchanged).
set -eu
ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
# Build into its own folder: an ad-hoc build over dist/ClipHistory.app breaks Accessibility for the running app.
BUILD="$ROOT/dist/release-build/ClipHistory.app"
CLIPHISTORY_ADHOC=1 CLIPHISTORY_OUT="$BUILD" "$ROOT/build.sh"
OUT="$ROOT/dist/release"
rm -rf "$OUT"
mkdir -p "$OUT"
ditto -c -k --keepParent "$BUILD" "$OUT/ClipHistory.zip"
( cd "$OUT" && shasum -a 256 ClipHistory.zip > ClipHistory.zip.sha256 )
lipo -info "$BUILD/Contents/MacOS/ClipHistory"
echo "Release files in $OUT"
