#!/usr/bin/env bash
# Installs the kimchi skill into Claude Code and/or Codex CLI.
#   ./install.sh          auto-detect installed agents (~/.claude, ~/.codex)
#   ./install.sh claude   Claude Code only  -> ~/.claude/skills/kimchi   (/kimchi)
#   ./install.sh codex    Codex CLI only    -> ~/.codex/skills/kimchi    ($kimchi or /skills)
#   ./install.sh all      both
set -euo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)/plugin"
[ -f "${SRC}/SKILL.md" ] || { echo "error: ${SRC}/SKILL.md not found — run from the cloned kimchi repo." >&2; exit 1; }

install_to() {
  local dest="$1"
  rm -rf "$dest"
  mkdir -p "$dest"
  cp "${SRC}/SKILL.md" "$dest/"
  cp -R "${SRC}/references" "$dest/"
  echo "🌶️  installed → $dest"
}

targets=()
case "${1:-}" in
  claude) targets=(claude) ;;
  codex)  targets=(codex) ;;
  all)    targets=(claude codex) ;;
  "")
    [ -d "$HOME/.claude" ] && targets+=(claude)
    [ -d "$HOME/.codex" ]  && targets+=(codex)
    [ ${#targets[@]} -eq 0 ] && targets=(claude)
    ;;
  *) echo "usage: ./install.sh [claude|codex|all]" >&2; exit 1 ;;
esac

for t in "${targets[@]}"; do
  case "$t" in
    claude) install_to "$HOME/.claude/skills/kimchi"; echo "   Claude Code → restart, then: /kimchi" ;;
    codex)  install_to "$HOME/.codex/skills/kimchi";  echo "   Codex CLI → restart, then: /skills or \$kimchi" ;;
  esac
done
