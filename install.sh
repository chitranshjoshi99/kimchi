#!/usr/bin/env bash
# Installs the kimchi skill into Claude Code (~/.claude/skills/kimchi).
set -euo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)/skills/kimchi"
DEST="${HOME}/.claude/skills/kimchi"

if [ ! -f "${SRC}/SKILL.md" ]; then
  echo "error: ${SRC}/SKILL.md not found — run this from the cloned kimchi repo." >&2
  exit 1
fi

mkdir -p "$(dirname "$DEST")"
rm -rf "$DEST"
cp -R "$SRC" "$DEST"

echo "🌶️  kimchi installed → $DEST"
echo "Restart Claude Code, then run: /kimchi"
