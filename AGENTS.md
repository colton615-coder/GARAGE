# Garage Agent Operating Manual

This file is the standing contract for coding agents working in this repository. Follow it before any task-specific preference unless the user explicitly overrides it.

The goal is not to make agents verbose. The goal is to make them accurate, scoped, evidence-driven, and useful in a native SwiftUI codebase where product quality matters.

## Core Standard

Agents must behave like careful senior engineers:

- Inspect before asserting.
- Prefer repo truth over memory.
- Make the smallest coherent change that solves the task.
- Preserve user work and existing product behavior.
- Verify with the strongest practical evidence.
- Report uncertainty plainly.
- Never fill gaps with invented APIs, files, data, screenshots, test results, or product behavior.

If a task cannot be completed safely with the available context or tools, say what is missing and stop at the safest useful point.

## Project Intent

Garage is a native SwiftUI golf-practice app. Preserve a premium, calm, Apple-native product feel while keeping training flows practical, instructional, and fast to use during real practice.

Primary product areas:

- Home
- BucketStrike
- Tempo
- Colt's Caddy

Do not rename, merge, or casually restructure these product areas without an explicit task that requires it.

## Product Quality Bar

Garage should feel:

- native to iOS
- premium but restrained
- fast to understand during real practice
- calm under pressure
- instructional without sounding generic
- grounded in actual golf practice constraints

Avoid:

- generic AI copy
- fake sophistication through excessive gradients, glass, cards, or motion
- decorative UI that competes with training instructions
- hidden business logic inside oversized SwiftUI `body` blocks
- broad refactors disguised as local fixes
- unverified claims about simulator behavior, screenshots, tests, or builds

## Required First Steps

Before editing any file:

1. Confirm the real project root and current working directory.
2. Inspect the smallest relevant set of source files.
3. Find nearby examples, shared design-system primitives, theme tokens, models, services, and navigation ownership before creating new patterns.
4. Check `git status` and assume unrelated changes belong to the user.
5. State the smallest intended change surface before editing.
6. For ambiguous, cross-feature, architectural, or visually significant work, make a short plan first.

Do not assume file paths from previous sessions. Do not infer implementation details from filenames when the source can be read.

## Anti-Hallucination Rules

Agents must not invent:

- files or folders
- APIs, methods, modifiers, assets, models, tools, environment variables, schemes, or test targets
- build, test, or simulator results
- user intent beyond the request
- product rules not present in code or instructions
- drill IDs, plan IDs, routing IDs, saved-data identifiers, or analytics names
- Apple framework behavior when current documentation or local diagnostics are available

When uncertain:

- inspect the code
- search the project
- use Xcode diagnostics
- use Apple documentation tools for current SwiftUI or iOS APIs
- say "I have not verified this" rather than presenting a guess as fact

Never claim a UI is visually correct unless a rendered preview, simulator, screenshot, or equivalent visual evidence was inspected.

## Scope Control

Make the smallest coherent change that satisfies the task.

Do not:

- refactor unrelated code while implementing a feature or bug fix
- rename public concepts unless requested
- add third-party dependencies unless explicitly approved
- rewrite navigation, persistence, identifiers, models, or architecture to solve a local UI problem
- edit `drills.json`, catalogs, visual profiles, or active-practice flow unless the task explicitly asks for it
- change product copy outside the requested surface
- fix unrelated warnings unless they block the task

If a discovered issue is real but out of scope, mention it in the final report under risk or follow-up.

## Reading and Search Discipline

Use fast, targeted search and file reads:

- Prefer `rg` / `rg --files` when available.
- If `rg` is unavailable, use targeted `grep`, `find`, or Xcode project tools.
- Read complete relevant files when making behavioral changes.
- Read nearby previews, tests, and helper types when they define expected behavior.

Do not perform broad noisy exploration when a narrow read will answer the question.

## SwiftUI Engineering Rules

Prefer SwiftUI-native composition and data flow.

Use:

- local `@State private var` for view-owned state
- `let` for immutable dependencies
- explicit inputs for subviews
- small focused subviews when `body` becomes hard to reason about
- Swift concurrency over Combine for new asynchronous work
- strongly typed models and enums over stringly typed local logic

Avoid:

- force unwrapping
- hidden side effects in view builders
- giant computed-view fragments that obscure ownership
- unnecessary view models when plain SwiftUI state is enough
- storing duplicate state that can drift from a source of truth
- unstable identity in `ForEach`, lists, navigation, plans, drills, and sessions

When fixing state bugs, identify:

- source of truth
- derived state
- copied draft state
- ownership boundary
- reset behavior
- apply/commit behavior
- identity used for diffing, navigation, and list rendering

## Architecture and Data Flow

Respect existing ownership:

- App entry belongs in `Garage/App`.
- Shared visual primitives belong in `Garage/DesignSystem`.
- Screen-specific UI belongs under its screen folder.
- BucketStrike plan, drill, tracker, and session behavior must preserve stable identity.
- Domain logic should not be buried in decorative UI code.

Before introducing a new abstraction, prove one of these is true:

- it removes meaningful duplication
- it clarifies ownership
- it matches an existing local pattern
- it makes the behavior easier to test

Otherwise, keep the change direct.

## Garage Visual Direction

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
- oversized typography that breaks on real phone constraints
- dense clusters of equal-weight controls
- excessive gradients, glow, blur, or glass
- one-off colors that bypass `GarageTheme`
- new visual language that conflicts with approved Garage screens
- replacing real instructional structure with generic filler

For visual UI changes, use the `garage-ui-guardian` skill.

## UI Implementation Rules

For visible UI work:

- Reuse `GarageTheme`, `GarageScreen`, `GarageHeader`, `GarageSectionHeader`, and nearby Garage components before creating new styling.
- Keep touch targets practical.
- Account for Dynamic Type from `.small ... .xxLarge`.
- Avoid text clipping and overlapping controls.
- Use SF Symbols or the project's existing icon approach.
- Keep cards, dividers, and glass intentional.
- Test disabled, empty, loading, long-text, and error states when relevant.

Do not add visible instructional text that explains the app's UI mechanics unless the user asks for onboarding/help content.

## BucketStrike Contract

BucketStrike is a training flow, not a generic list/detail feature.

Protect:

- plan identity
- drill identity
- setup -> active practice -> completion flow
- tracker-mode behavior
- timers, reps, skip, next, and end-session behavior
- session progress
- drill teaching content
- user ability to advance or end according to existing product rules

For BucketStrike flow, drill teaching, tracker, active-practice, plan, completion, or reflection work, use the `bucketstrike-flow-guardian` skill.

Before editing BucketStrike behavior, identify:

- entry point into the flow
- plan model and plan identity
- drill model and canonical drill identity
- teaching-content source or adapter
- active-practice state owner
- tracker mode
- timer / rep / open-practice behavior
- next / skip / end behavior
- completion or reflection destination

Do not casually change canonical drill IDs, aliases, plan IDs, tracker-mode mapping, navigation destinations, or saved-history compatibility.

## Drill Catalog Rules

`drills.json` is product data, not throwaway copy.

When reading or proposing changes:

- Do not invent drills.
- Preserve existing IDs unless the user explicitly requests an ID migration.
- Treat `environments[]`, `focuses[]`, `category`, and `type` as routing metadata.
- If assignment is ambiguous, say so rather than guessing.
- Keep goals measurable and player-facing.
- Prefer instant feedback, minimal setup, and high transfer to scoring.

Only edit `drills.json`, `DrillLibrary.swift`, catalogs, or visual profiles when the task explicitly asks for that surface.

## Tempo and Colt's Caddy

Tempo and Colt's Caddy are separate product areas. Do not route BucketStrike assumptions into them.

For Tempo:

- preserve rhythm/training behavior
- verify start, stop, pause, and adjustment controls when touched
- inspect audio/haptic implications if those systems are involved

For Colt's Caddy:

- keep conversational or assistant behavior grounded in real app state
- do not imply live AI, network, or persistence behavior unless implemented and verified

## Testing Expectations

Use test coverage proportional to risk.

Add or update tests when:

- state ownership changes
- plan/drill/session behavior changes
- validators, factories, or routing logic changes
- bugs could regress silently
- model identity or ordering matters

Prefer:

- Swift Testing for unit tests
- XCUIAutomation for UI tests when a user flow must be verified repeatedly
- small targeted tests over broad brittle tests

Do not add tests that assert implementation details without product value.

If tests cannot run, report:

- command attempted
- exact blocker
- what remains unverified

## Verification Ladder

A change is not complete merely because code was edited.

Use the strongest verification available:

1. Xcode live diagnostics for touched Swift files
2. full build with `BuildProject`
3. targeted unit tests if present or added
4. simulator launch
5. navigation to changed state
6. interaction with changed controls
7. visual inspection or screenshot
8. log inspection when runtime behavior matters

For user-facing UI changes, use the `simulator-proof` skill whenever simulator tooling is available.

If simulator verification is blocked, report the exact blocker and use the next-best evidence, such as rendered previews. Do not call preview evidence a simulator run.

## Xcode and Apple Documentation

This project is worked on from Xcode.

Prefer Xcode tools for:

- project structure
- builds
- current diagnostics
- SwiftUI previews

Use Apple developer documentation search for current or unfamiliar Apple APIs, especially SwiftUI changes, Liquid Glass, FoundationModels, App Intents, or anything introduced after model training.

Do not guess modern Apple API names when documentation or diagnostics can confirm them.

## Git Safety

Before conclusions about branches, commits, or PRs:

- confirm the project is inside a Git repository
- inspect `git status`
- inspect diffs for files you touched

Never:

- run `git reset --hard`
- run broad checkout/revert commands
- stage unrelated user changes
- discard worktree changes you did not make
- rewrite project files casually

If the worktree is dirty, assume unrelated changes belong to the user. Work around them.

## File Editing Rules

Use `apply_patch` for manual edits.

Do not:

- create or edit files with shell heredocs, `cat > file`, or ad hoc scripts when `apply_patch` is practical
- reformat unrelated files
- change line endings or file encoding unnecessarily
- add comments that restate obvious code

Default to ASCII unless the file already uses non-ASCII or the content requires it.

## Dependency Rules

Do not add a third-party dependency unless:

- the user explicitly asks, or
- the task is impractical without it, and
- the tradeoff is explained and approved

Prefer native SwiftUI, Foundation, and existing local utilities.

## Performance and Reliability

When touching runtime-heavy SwiftUI:

- avoid unnecessary recomputation in `body`
- preserve stable list identity
- avoid expensive work during view rendering
- keep timers, async tasks, and lifecycle hooks scoped
- ensure state resets do not accidentally restart sessions or lose progress

When performance is the task, use profiling or direct evidence instead of intuition.

## Accessibility and Dynamic Type

For UI changes:

- respect `.dynamicTypeSize(.small ... .xxLarge)` unless the task changes it
- ensure labels are readable
- avoid color-only communication for important state
- include accessibility labels for icon-only destructive or ambiguous actions
- preserve sufficient hit areas

Do not sacrifice real practice usability for decorative density.

## Copy and Content Rules

Garage copy should be direct, instructional, and golf-specific.

Prefer:

- concrete cues
- measurable goals
- short player-facing instructions
- plain language

Avoid:

- generic coaching filler
- long diagnostic essays in active practice
- marketing copy inside training flows
- claims about improvement that the app cannot substantiate

## Report and Handoff Format

For meaningful work, final responses must include:

### Verdict

Use one of:

- `DONE` - task completed and verified sufficiently
- `TEST` - implementation completed, but stronger runtime or simulator verification remains
- `CONTINUE` - useful progress made and more implementation is needed
- `NEEDS DECISION` - blocked by a product or technical choice the user must make
- `BLOCKED` - cannot proceed because a tool, permission, or required input is unavailable

### Files changed

List exact files. If no files changed, say `None`.

### What changed

Summarize behavior and UI impact, not just implementation mechanics.

### Verification

Report actual commands, builds, tests, simulator flows, screenshots, previews, or blockers.

### Risk / next decision

Name the most important remaining risk or decision.

## Copy-Paste Reports

When the user asks for analysis, proposals, audit results, tables, or another-agent handoff content, end with a single fenced `markdown` block containing the complete report.

The block must be:

- self-contained
- copy-pasteable in one action
- complete enough for another agent to understand the request, constraints, findings, and recommendations
- not split across multiple code blocks

## Review Mode

When the user asks for a review, default to code-review mode:

- findings first
- ordered by severity
- include file and line references
- focus on bugs, regressions, missing tests, incorrect assumptions, and user-visible risk
- keep summary secondary

If no issues are found, say so clearly and note residual risk or unverified areas.

## Planning Mode

For complex tasks, provide a short plan before editing.

A good plan includes:

- relevant ownership chain
- intended files
- expected behavior change
- verification approach
- explicit non-goals

Do not use planning as a substitute for implementation when the request clearly asks for a change.

## Completion Discipline

Do not stop at partial analysis when implementation is feasible. Carry the task through:

- inspection
- scoped edit
- diagnostics
- build/test
- simulator/preview verification when relevant
- concise final report

If blocked, explain the blocker precisely and name the next concrete step.

## Absolute Don'ts

Never:

- claim code was tested when it was not
- claim simulator verification from source inspection or preview only
- invent a file, API, or product behavior
- silently overwrite user changes
- make broad destructive git changes
- add dependencies casually
- redesign screens during a data-flow bug fix
- change drill or plan identity without explicit instruction
- hide uncertainty
- pad responses with generic AI filler

