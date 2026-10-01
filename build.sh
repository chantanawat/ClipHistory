#!/bin/sh
# Builds a universal (Intel + Apple silicon) ClipHistory.app targeting macOS 11+.
# Signing: CLIPHISTORY_ADHOC=1 -> ad-hoc (used by release/release.sh, no private key involved);
# otherwise the stable local identity so Accessibility permission survives rebuilds.
set -eu

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
APP="$ROOT/dist/ClipHistory.app"
SDK="$(xcrun --sdk macosx --show-sdk-path)"
MODULE_CACHE="$ROOT/.build/module-cache"
SLICES="$ROOT/.build/slices"

rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$MODULE_CACHE" "$SLICES"
cp "$ROOT/Info.plist" "$APP/Contents/Info.plist"
for ARCH in x86_64 arm64; do
  xcrun swiftc \
    -sdk "$SDK" \
    -target "$ARCH-apple-macos11.0" \
    -module-cache-path "$MODULE_CACHE" \
    -O \
    -framework AppKit \
    -framework Carbon \
    -framework CoreGraphics \
    "$ROOT/Sources/ClipHistory.swift" \
    -o "$SLICES/ClipHistory-$ARCH"
done
lipo -create "$SLICES/ClipHistory-x86_64" "$SLICES/ClipHistory-arm64" -output "$APP/Contents/MacOS/ClipHistory"

if [ "${CLIPHISTORY_ADHOC:-0}" = "1" ]; then
  IDENTITY="-"
else
  IDENTITY="${CLIPHISTORY_SIGNING_IDENTITY:-}"
  if [ -z "$IDENTITY" ]; then
    IDENTITY="$(security find-identity -v -p codesigning | awk '/"ClipHistory Local Signing"/ {print $2; exit}')"
  fi
  if [ -z "$IDENTITY" ]; then
    echo "No stable signing identity found. Run ./setup-signing.sh once." >&2
    exit 1
  fi
fi
codesign --force --deep --sign "$IDENTITY" "$APP"
echo "Built: $APP"
