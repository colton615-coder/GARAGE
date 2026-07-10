# Garage — Product Direction

*Audience: AI coding agents (Codex, Xcode agent, Claude). Read this before building anything. It defines what Garage is, what it is not, and where it's going.*

---

## 1. What Garage Is

Garage is a local-first iOS golf training app that replaces aimless practice with structure. The problem it solves: a golfer at a range or short-game area hitting balls with no plan, reinforcing bad swings. Garage gives every session intent — it helps the player decide what to work on, shows them exactly how to set up and execute, and stays out of the way while they hit.

> **Direction:** the long-term goal is for Garage to *program* the session — actively decide what to work on based on the player and location — not just help them choose. Build toward this; don't assume it exists yet.

The experience target is **premium but minimal**: smooth, polished, visually appealing, information-rich, with as little tapping as possible. Instruction is delivered through brief visuals — annotated stills and looping GIFs — not walls of text. The app teaches before the swing and goes quiet during it.

Garage adapts to where the player is. Range, short-game area, backyard — it keeps a well-maintained, structured, productive session regardless of location.

---

## 2. Principles

These are non-negotiable. When a design or code decision conflicts with one of these, the principle wins.

1. **Minimal tapping.** The player's phone is on the ground during a drill. Every required interaction is a cost. Zero mid-drill taps; results are batched to the end of the drill.

2. **Show, don't tell.** Instruction is visual first — annotated stills and GIFs of stick placement, address, and execution. Text is a caption, not a paragraph.

3. **One instruction per line.** Copy is plain and short. Never stack multiple instructions into one sentence. Separate the *what to do* from *how it's scored* — scoring is app logic, not something the player parses.

4. **Two phases, flipped visual weight.** Setup phase (before the swing) is instruction-heavy: visuals are the hero. Execution phase (hitting balls) is quiet: the cue stays glanceable-small, visuals collapse. The one exception: timer/tempo drills go loud during execution — big, bright, pacing visual. (This loud pacing visual is *output* — the app showing rhythm — not *tracking*. It does not read or require player input. The ban in Principle 5 is on input/tracking, not on output. See Principle 5.)

5. **Teach then get out of the way.** Once the player is hitting, the screen has done its job. No player input mid-drill — no live rep-tracking, no button-hunting, no scrolling. (Passive output the player doesn't interact with, like a tempo pacing visual, is allowed — see Principle 4. The ban is specifically on requiring the player to *do* something.)

6. **Local-first.** No network dependency for core practice. No new third-party dependencies without explicit human approval.

7. **BucketStrike executes; Colt's Caddy talks.** The voice/advisory layer belongs to Colt's Caddy. BucketStrike instructs and then stays silent. Don't blur the two. Caddy is advisory and read-only: it never creates, mutates, or deletes user data.

---

## 3. What Garage Is NOT

This section is the anti-scope fence. If a task drifts toward anything here, stop and flag it — don't build it.

1. **No manual live rep-tracking.** Banned. The player does not tap per-swing. No increment/decrement/reset-per-rep interfaces. Results are entered once, batched, at the end of a drill. This is permanent. (Automatic counting — e.g. future video verification, Open Questions #1 — is compatible with this rule; the ban is on requiring player interaction mid-drill.)

2. **No multi-skin UI proposals.** The five preview-gallery proposals (Scoreboard Ring, Rep Ladder, Focus First, Console, Thumb Reach) are dead — they were live-tracker reskins. If they exist as code (e.g. a `BucketStrikePreviewGallery` file), they may be deleted; if conversation-only, ignore. Don't revive or extend them.

3. **No text-wall instruction.** Never solve an instruction problem by adding more words — the answer is a better visual (Principle 2). Never stack multiple directions or scoring logic into one sentence (Principle 3).

4. **No advisory/voice in BucketStrike.** The coaching voice belongs to Colt's Caddy, a separate tab. BucketStrike instructs visually and stays silent. Do not add conversational or advisory features here.

5. **No fabricated data.** All drill content comes from the verified drill library (`DrillLibrary.swift` + `drills.json`). Never hardcode a parallel catalog, invent drill names, or regenerate reviewed copy from raw fields. (This has happened before — a fake `BucketPlanCatalog` fed the UI fabricated drills. Do not repeat it.)

---

## 4. The Four Tabs

State labels: **shipped** = real working feature. **shell** = UI placeholder, no real logic. **not started** = nothing built. All four tabs are currently shell-stage except where noted.

- **Home** — session launchpad: today's focus, carry-forward notes, entry to the tools. **Shell** — layout exists, content is placeholder, no real data or routing.
- **BucketStrike** — structured practice: generates drills, briefs the setup visually, batches the results. Current active build focus. **Partial** — real drill library and domain models exist; the active-practice flow is mid-refactor (see Direction #1).
- **Tempo** — swing-rhythm trainer: paced, timer-driven, loud during execution. **Shell** — visual placeholder only, no timing engine.
- **Colt's Caddy** — the advisory voice: course strategy and decisions, conversational, **read-only** (advises; does not create, mutate, or delete user data). **Shell** — static conversation UI only, no real input or responses.

---

## 5. Product Direction

Priorities in order. Higher items are more important, but the ordering is not a hard gate: on-device verification is human-owned, so agents never block indefinitely waiting for it. Work the highest item you can actually make progress on.

1. **Batch-entry refactor (issued, unconfirmed).** A directive to replace live rep-tracking with end-of-drill batch result entry has been issued to an agent but **not confirmed applied or verified on device**. Repo reality: the codebase may still contain live-tracking code, or a half-applied migration. Treat any live-tracking remnants as bugs to remove, not patterns to build on. Batch entry is the intended interaction model everything below assumes. On-device verification is human-owned; agents may not self-verify this — but agents may proceed on #2 and #3 in parallel rather than blocking on it.

2. **Guided visuals per drill.** Every drill gets a setup visual (stick/gate placement, address) and a brief execution visual (still or GIF). The six placeholder `visualConfig` cases get real art. A sourced visual reference library is being compiled externally to feed this; its location is not yet established — **#2 is not blocked on it. Agents may build the visual-rendering plumbing (config → asset routing) now; real art can be dropped in when the library lands.** This is the single biggest gap between the current app and the product vision.

3. **Copy standard pass.** Rewrite drill copy to Principle 3 (one instruction per line, scoring separated from instruction). Separately: the 14 `BucketDrillVisualProfile` entries are suspected of having been regenerated from raw drill fields rather than human-reviewed drafts. Verifying this requires the reviewed drafts, whose location is not established in-repo — **this specific check is human-gated; an agent cannot perform it until the reference drafts are provided.** The copy rewrite itself is not gated and can proceed.

4. **Tempo tab construction.** Real timing engine, BPM/ratio settings, loud execution-phase visual (the one sanctioned loud screen). Engine lives outside the view body.

5. **Colt's Caddy construction.** Local deterministic conversation shell first, AI boundary after. Caddy never silently mutates user data.

6. **Session programming (long-term).** Garage decides what to practice based on player, history, and location. This is the "Direction" note in Section 1 made real. Requires persisted session results first.

### Doc hygiene (directive note)
The repo/docs folder contains stale July-3 starter documents describing a pre-rebuild prototype that no longer exists. **Any agent directive touching docs must archive (move to a `Docs/_archive/` folder — never hard-delete) these specific files:** `GARAGE_CURRENT_STATE.md`, `GARAGE_PRODUCT_TO_REPO_GAP_ANALYSIS.md`, `GARAGE_STATE_OWNERSHIP_MAP.md`, `GARAGE_NAV_ARCHITECTURE.md`, `GARAGE_NAVIGATION_MAP.md`, `GARAGE_SCREEN_SPECS.md`, `CODEX_STARTER_PLAN.md`. This file supersedes them. **Keep unconditionally:** `GARAGE_BUILD_ROADMAP.md` (phase ordering), `GARAGE_TECHNICAL_ARCHITECTURE.md` (boundary rules), and `GARAGE_UI_KIT.md` (retain despite its known color contradiction — the fix is a pending human decision, see Open Questions #2; do not delete it over that contradiction). Agents must not delete or archive any file not on the explicit archive list above.

---

## 6. Open Questions

Unresolved bets. Do not build these without explicit direction; do not treat them as scoped features.

1. **Video capture → verified swing analysis.** The vision: the phone films the player during a drill, verifies each swing as successful or not against the drill's criteria, and increments the completion count automatically — replacing even batch entry. Zero-tap, fully automatic.
   - Honest difficulty gradient: detecting *that a swing occurred* is feasible on-device (motion/pose). Verifying *drill-specific success* (e.g. club missed the gate rod, ball started on line) from a single phone camera is hard computer vision and may not be reliably solvable.
   - If pursued, step it: (a) record + auto-clip swings for manual review, (b) swing detection as an auto-counter with manual success marking, (c) full success verification only if (a)/(b) prove out.
   - Not scheduled. Batch entry is the interaction model until this earns its way in.

2. **UI kit color contradiction.** `GARAGE_UI_KIT.md` says blue owns primary actions; the shipped app uses green. Pending human decision on which is canon; until then, agents leave both as-is and do not "fix" either.

3. **Home's future depth.** Currently a launchpad. Whether it grows session summaries/history depends on persistence landing (Direction #6 prerequisite).
