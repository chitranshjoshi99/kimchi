# 🌶️ kimchi

**A product-thinking layer for people who vibe code.**

You get ideas constantly. The problem was never the idea — it's everything between the
idea and a working app. You open your AI tool, type a vague prompt, and jump straight to
execution... only to discover vibe coding isn't as straightforward as it looked. The AI
fills gaps you never specified, builds the wrong thing, and 90% of the time direct
prompting just produces **slop**. A few frustrating hours later, motivation is gone and
the idea joins the graveyard of things you never built.

kimchi fixes the part before the code. It takes your raw idea and **ferments it** — drops
it into a room of thirteen world-class expert personas (a product head, an architect, a
designer, a security expert, a lazy staff engineer, a finance head, and more) who
**grill you, counter you, and refuse to flatter you** until the idea is airtight. Then it
compiles everything into concise, build-ready docs — locked decisions, API contracts, tech
stack, and a story-by-story plan — plus an `execute.md` that lets Claude Code **build the
whole thing autonomously across multiple sessions**, no hand-holding.

Raw ingredients in. Pressure and time. Something structured and sharp comes out. That's the
name.

> Direct prompting creates AI slop. kimchi creates a plan the AI can actually follow.

---

## What it does

- **Grills the idea.** Summon experts one at a time; each interrogates your idea in their
  domain until ~9 of 10 hard questions have clean answers. No "great idea!" — real friction.
- **No appeasement.** Every persona recommends _with reasons_ and tells you when you're
  hand-waving past a real problem.
- **Compiles build docs.** One doc per EPIC — user stories, business severity/complexity,
  priority order, locked tech decisions, API contracts, and a tracker.
- **Self-driving build.** An `execute.md` handoff so Claude Code builds story-by-story in
  priority order across separate sessions, resuming from trackers.
- **Audits before you build.** A pre-build audit gate catches flawed or contradictory
  decisions while they're still a doc edit — not a rewrite.

## The personas

`PH` product-head · `CF` co-founder · `ARCH` architect · `DG` design-girl · `TB` tech-bro
(lazy staff eng) · `SM` security-master · `DO` devops · `FB` finance-bro · `DS`
data-scientist · `LB` legal-bro · `COO` operations · `EM` engineering-manager · `AUD`
auditor.

## Install

Works in **[Claude Code](https://claude.com/claude-code)** and **[Codex CLI](https://developers.openai.com/codex)**
— both read the same `SKILL.md` format.

### Claude Code — plugin (recommended: auto-updates)

```
/plugin marketplace add chitranshjoshi99/kimchi
/plugin install kimchi@ceejay
```

Update later with `/plugin marketplace update ceejay`. kimchi ships as a single skill, so
it invokes with the clean name **`/kimchi`** (e.g. `/kimchi PH`) — no namespace prefix.

### Claude Code / Codex — clone + install script

```bash
git clone https://github.com/chitranshjoshi99/kimchi.git
cd kimchi
./install.sh          # auto-detects installed agents
# or force one:  ./install.sh claude | codex | all
```

- **Claude Code** → `~/.claude/skills/kimchi/` → invoke `/kimchi`
- **Codex CLI** → `~/.codex/skills/kimchi/` → invoke via `/skills` menu or `$kimchi`

**Restart the agent** after installing so it picks up the skill.

### Codex — manual

Copy the skill into your Codex skills directory (personal or project-local):

```bash
git clone https://github.com/chitranshjoshi99/kimchi.git
mkdir -p ~/.codex/skills/kimchi
cp -R kimchi/plugin/SKILL.md kimchi/plugin/references ~/.codex/skills/kimchi/
```

## Usage

Invoke `/kimchi` (Claude Code) or `$kimchi` (Codex). Arguments are the same either way.

```
/kimchi              # no argument — full product-development lifecycle, guided
/kimchi CF           # summon one persona by name or acronym (co-founder here)
/kimchi PH           # product-head — builds the EPIC → STORY → TASK breakdown
/kimchi generate     # compile the build docs (README, EPIC-*.md, execute.md)
/kimchi audit        # run the auditor over the docs (do this before you build)
```

Start with `/kimchi` and let it walk you through. Answer honestly — it's designed to catch
you when you don't.

## License

MIT
