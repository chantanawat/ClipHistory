#!/bin/sh
# Builds the universal app (ad-hoc signed) and packs dist/release/ClipHistory.zip + .sha256
# Run from anywhere. Upload both files to a GitHub Release (asset names must stay unchanged).
set -eu
ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
CLIPHISTORY_ADHOC=1 "$ROOT/build.sh"
OUT="$ROOT/dist/release"
rm -rf "$OUT"
mkdir -p "$OUT"
ditto -c -k --keepParent "$ROOT/dist/ClipHistory.app" "$OUT/ClipHistory.zip"
( cd "$OUT" && shasum -a 256 ClipHistory.zip > ClipHistory.zip.sha256 )
lipo -info "$ROOT/dist/ClipHistory.app/Contents/MacOS/ClipHistory"
echo "Release files in $OUT"
