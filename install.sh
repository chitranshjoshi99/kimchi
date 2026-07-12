#!/usr/bin/env bash
# Installs the kimchi skill standalone into Claude Code (~/.claude/skills/kimchi),
# giving the clean /kimchi invocation. (The plugin install also uses /kimchi — see README.)
set -euo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)/plugin"
DEST="${HOME}/.claude/skills/kimchi"

if [ ! -f "${SRC}/SKILL.md" ]; then
  echo "error: ${SRC}/SKILL.md not found — run this from the cloned kimchi repo." >&2
  exit 1
fi

rm -rf "$DEST"
mkdir -p "$DEST"
cp "${SRC}/SKILL.md" "$DEST/"
cp -R "${SRC}/references" "$DEST/"

echo "🌶️  kimchi installed → $DEST"
echo "Restart Claude Code, then run: /kimchi"
