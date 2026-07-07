# Garage Codex Working Agreement

## Project intent

Garage is a native SwiftUI golf-practice app. Preserve a premium, calm, Apple-native product feel while keeping training flows practical, instructional, and fast to use during real practice.

Primary product areas:
- Home
- BucketStrike
- Tempo
- Colt's Caddy

Do not rename, merge, or casually restructure these product areas without an explicit task that requires it.

## Before editing

1. Confirm the real project root and working directory. Do not assume old absolute paths from documentation or prior sessions.
2. Inspect the smallest relevant set of source files before proposing changes.
3. Find existing shared design-system components, theme tokens, models, services, navigation ownership, and nearby implementation examples before adding new ones.
4. State the smallest intended change surface before editing.
5. For complex, ambiguous, cross-feature, or architectural work, plan first.

## Scope control

- Make the smallest coherent change that satisfies the task.
- Do not refactor unrelated code while implementing a feature or UI change.
- Do not add third-party dependencies unless explicitly requested or clearly necessary and approved.
- Do not silently rewrite architecture, routing, persistence, identifiers, or domain models to solve a local UI problem.
- Preserve existing behavior unless behavior change is part of the request.
- When the working tree contains unrelated changes, do not overwrite, revert, stage, or discard them.

## SwiftUI expectations

- Prefer SwiftUI-native composition and data flow.
- Keep view-owned state local.
- Keep business and domain logic out of large `body` implementations.
- Prefer focused subviews with explicit inputs over giant screen files or sprawling computed-view fragments.
- Reuse shared Garage primitives and tokens before creating one-off styling.
- Avoid unnecessary view models when plain SwiftUI state and injected services are sufficient.
- Preserve stable identity in lists, drill models, plans, and navigation.
- Build after meaningful structural edits before continuing into a larger change.

## Garage visual direction

The app should feel premium, restrained, and performance-oriented.

Default direction:
- dark system foundation
- deep black-green / emerald identity
- restrained gold accents
- selective glass, not glass on every surface
- editorial spacing and hierarchy
- thin dividers where a full card is unnecessary
- strong primary action hierarchy
- low visual noise
- readable instructional content

Avoid:
- card-on-card nesting
- decorative UI that competes with training instructions
- oversized typography that breaks on real phone constraints
- dense clusters of equal-weight controls
- excessive gradients, glow, blur, or glass
- new visual language that conflicts with approved Garage screens
- replacing real instructional structure with generic AI-sounding copy

For visual UI changes, use the `garage-ui-guardian` skill.

## BucketStrike

BucketStrike is a training flow, not a generic list/detail feature.

Protect:
- plan identity and drill identity
- setup -> active practice -> completion flow
- tracker-mode behavior
- session progress
- drill teaching content
- user ability to advance or end according to existing product rules

For BucketStrike flow, drill teaching, tracker, active-practice, plan, or completion work, use the `bucketstrike-flow-guardian` skill.

## Verification

A change is not complete merely because code was edited.

Use the strongest verification available:
1. compile/build
2. targeted tests if present
3. simulator launch
4. navigate to changed state
5. interact with changed controls
6. inspect visible result
7. inspect logs when runtime behavior matters

For user-facing UI changes, use the `simulator-proof` skill whenever simulator tooling is available.

If verification is blocked by environment problems, report:
- what was attempted
- the exact blocker
- what remains unverified

Never claim visual success from source inspection alone.

## Git safety

- Detect whether the project is actually inside a Git repository before giving branch, commit, or PR conclusions.
- Inspect `git status` and the diff before staging or reverting anything.
- Never use broad destructive cleanup commands on a mixed worktree.
- Never stage unrelated user changes.
- Prefer draft PRs for agent-generated changes unless explicitly asked otherwise.

## Completion report

End meaningful work with:

### Verdict
Use one of: TEST, CONTINUE, NEEDS DECISION, BLOCKED, or DONE.

### Files changed
List exact files.

### What changed
Summarize behavior and UI impact, not just implementation mechanics.

### Verification
Report actual commands, simulator flows, screenshots, tests, or blockers.

### Risk / next decision
Name the one most important remaining risk or decision. Keep it brief.
