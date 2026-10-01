#!/bin/sh
# Removes ClipHistory (app, login item). Asks before deleting your saved history.
set -eu
pkill -x ClipHistory 2>/dev/null || true
sleep 1
rm -rf "/Applications/ClipHistory.app" "$HOME/Applications/ClipHistory.app" 2>/dev/null || true
rm -f "$HOME/Library/LaunchAgents/local.personal.ClipHistory.plist"
DATA="$HOME/Library/Application Support/ClipHistory"
if [ -d "$DATA" ]; then
  printf 'Also delete saved clipboard history? [y/N] '
  ANSWER=""
  read -r ANSWER < /dev/tty || true
  case "$ANSWER" in y|Y) rm -rf "$DATA"; echo "History deleted." ;; *) echo "History kept." ;; esac
fi
echo "ClipHistory removed. You can also remove it from System Settings > Privacy & Security > Accessibility."
