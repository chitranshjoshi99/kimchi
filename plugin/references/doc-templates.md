# Templates — context handoff, EPIC docs, audit

All kimchi artifacts live in `docs/product/` in the repo. Create the directory
if missing.

---

## 1. `context.md` — the handoff file

The running memory of the whole session. Every persona reads it on entry and appends a
block on exit. Keep blocks tight — this is briefing material for the next expert, not a
transcript.

On first creation, start with:

```markdown
# Product context

**Product:** <one-line description>
**Status:** in discovery

---
```

Each persona appends:

```markdown
## <Persona name> — <YYYY-MM-DD>

**Clarity gate:** met / not met (<n>/10 problems answered cleanly)

**Decisions locked:**
- <decision> — because <reason>

**Recommendations:**
- <recommendation> — <reason>

**Open risks / unknowns:**
- <risk> (severity: …) — <why unresolved>

**For the next persona:**
- <what they most need to know>

---
```

---

## 2. `EPIC-<n>-<slug>.md` — one per epic

Produced on `generate`. Concise, resumable build instructions for Claude across separate
sessions. Structure is fixed: **table → instructions → tracker.**

```markdown
# EPIC <n>: <epic title>

<2-3 sentence statement of the epic's business goal and the user outcome it delivers.>

## User stories

| # | User story | Severity | Complexity | Priority |
|---|-----------|----------|------------|----------|
| 1 | As a <user>, I want <capability> so that <outcome>. | Critical | Medium | 1 |
| 2 | … | High | Low | 2 |

> Severity & complexity are **business/conceptual** metrics. Development effort is
> deliberately ignored (see grilling-doctrine §6). Priority is a strict order.

## Locked decisions

Non-negotiable choices a future build session must not re-litigate:

- **Tech stack:** <languages, frameworks, DB, key libs>
- **Architecture:** <the shape decided by ARCH — services, data flow, boundaries>
- **Deployment:** <the target from DO, right-sized for current scope>
- **Security:** <the must-haves from SM — authn/z, data handling, threat mitigations>
- **Design:** <theme/UX direction from DG>
- **Legal/compliance:** <constraints from LB>
- **Data/market basis:** <the numbers from DS/FB that justify this epic's priority>

## Execution instructions (priority order)

Execute stories in the priority order above. For each, enough for a fresh session to
build it without re-deciding anything:

### 1. <story 1 title>  (Priority 1)
- **Goal:** <what "done" means, in business terms>
- **API contract:** <endpoints, methods, request/response shapes — lock exact schemas>
- **Data model:** <tables/entities/fields touched>
- **Key decisions:** <the specific choices already made for this story>
- **Acceptance:** <observable checks that prove it works>

### 2. <story 2 title>  (Priority 2)
- …

## Tracker

| # | User story | Status | Session | Notes |
|---|-----------|--------|---------|-------|
| 1 | <short label> | Not started | — | — |
| 2 | <short label> | Not started | — | — |

> Status ∈ {Not started, In progress, Blocked, Done}. Each build session updates this
> table before finishing so the next session knows where it left off.
```

### How to split epics
One epic = one coherent slice of user value (product-head's EPIC level). If a doc's
story table runs past ~8 rows, it's probably two epics — split it.

---

## 3. `README.md` — product overview + net tracker

Written on `generate`, alongside the EPIC docs. The front door: what the product is, plus
a single master tracker that compiles every EPIC's tracker rows into one table.

```markdown
# <Product name>

<2-4 sentence description: what it is, who it's for, the core value.>

**Wedge:** <the narrow first slice, from CF/PH>
**Status:** <discovery / building / shipped>

## Epics

| Epic | Title | Goal | Doc |
|------|-------|------|-----|
| 1 | <title> | <one line> | [EPIC-1](EPIC-1-<slug>.md) |
| 2 | … | … | … |

## Key locked decisions (product-wide)

- **Tech stack:** … · **Architecture:** … · **Deployment:** … · **Security:** …
- (the cross-cutting choices every session must honor — pull from the EPIC docs)

## Net tracker

Every story across every epic, in one place. Each build session updates its rows here
*and* in the epic doc.

| Epic | # | User story | Severity | Priority | Status | Session | Notes |
|------|---|-----------|----------|----------|--------|---------|-------|
| 1 | 1 | <label> | Critical | 1 | Not started | — | — |
| 1 | 2 | <label> | High | 2 | Not started | — | — |
| 2 | 1 | <label> | … | … | Not started | — | — |

> Status ∈ {Not started, In progress, Blocked, Done}.
```

---

## 4. `execute.md` — self-driving handoff for Claude Code

Written on `generate`. This is the instruction set a **fresh Claude Code session** reads to
build the product **without the user prompting each step**, across many separate sessions.
It must be self-contained: a session that has never seen the discussion can pick it up cold.

```markdown
# Execute — autonomous build handoff

You are building the product described in `README.md`. Implement it across multiple
sessions **without waiting for user prompts between steps**. Everything you need is locked
in `README.md` and the `EPIC-*.md` docs — do not re-litigate decisions already made there.

## Before the first build session — pre-build audit gate

Do not write code until the docs have passed a pre-build audit. If `docs/product/AUDIT.md`
does not exist or is stale, run the kimchi Auditor in **pre-build mode** over the docs (it
re-checks every persona's locked decisions for contradictions, flawed calls, and gaps
between personas — the cheapest place to catch a bad architecture is before it's built).
Resolve every **Revise** finding — edit the affected EPIC doc, then continue. This gate
exists because a flawed decision caught here is a doc edit; caught after building, it's a
rewrite.

## Each session, do this

1. Read `README.md` (product + net tracker) and the relevant `EPIC-<n>-<slug>.md`.
2. Find the next unblocked story by **priority order** in the net tracker (Status = Not
   started, dependencies Done). That is your task for this session.
3. Set its Status to **In progress** in both the epic tracker and the net tracker.
4. Build it to the story's **acceptance** criteria, honoring the **locked decisions** (tech
   stack, API contracts, architecture, security, design) — these are fixed; build to them.
5. Verify it works (run it / test it — observe real behavior, not just types).
6. Update both trackers: Status → **Done** (or **Blocked** + reason), fill Session + Notes.
7. Commit with a conventional-commit message referencing the epic + story.
8. If session budget remains, go to step 2 for the next story. Otherwise stop cleanly —
   the trackers are the resume point for the next session.

## Rules
- **Build order = priority order** across the net tracker. Don't cherry-pick.
- **Locked decisions are locked.** If a doc says Postgres + REST, you use Postgres + REST.
  If reality makes a locked decision impossible, mark the story **Blocked**, write why, and
  move on — don't silently swap a load-bearing decision.
- **Resume from trackers.** The only source of truth for "what's done" is the net tracker.
  Keep it honest and current every session, or the next session double-builds or stalls.
- **Ship the lazy version that meets acceptance** (tech-bro's approach in the docs), but
  never skip validation, security, or error handling flagged as required.

## Build order
<generate emits the concrete priority-ordered story sequence here, e.g.:>
1. EPIC-1 · Story 1 — <label>
2. EPIC-1 · Story 2 — <label>
3. EPIC-2 · Story 1 — <label>
…
```

---

## 5. `AUDIT.md` — the Auditor's report

```markdown
# Product audit — <YYYY-MM-DD>

Reviewed after: <build complete / docs generated>

| Persona | Verdict | Regrets / drift | Fix |
|---------|---------|-----------------|-----|
| Product-head | Holds / Revise | <what changed vs. plan> | <action> |
| Architect | … | … | … |

## Detail

### <Persona> — <Holds / Revise>
<what the persona re-examined, what it would now decide differently and why, or why the
original call still stands.>
```
