# Garage Codex Routing Guide

Use this as the decision table for which workflow should run.

| Task | Primary skill | Add-on skill |
|---|---|---|
| New SwiftUI screen | swiftui-ui-patterns | garage-ui-guardian |
| Existing UI redesign | garage-ui-guardian | simulator-proof |
| Large SwiftUI file cleanup | swiftui-view-refactor | garage-safe-change |
| BucketStrike plan flow | bucketstrike-flow-guardian | simulator-proof |
| Active drill cockpit | bucketstrike-flow-guardian | garage-ui-guardian + simulator-proof |
| Tempo jank or CPU issue | swiftui-performance-audit | ios-ettrace-performance if code review is inconclusive |
| Suspected memory leak | ios-memgraph-leaks | ios-debugger-agent |
| Figma to SwiftUI | figma-swiftui | garage-ui-guardian |
| SwiftUI to Figma | figma-swiftui | figma-generate-design when building a composed screen |
| Failed GitHub Actions check | gh-fix-ci | garage-safe-change |
| PR review feedback | gh-address-comments | garage-safe-change |
| Commit, push, draft PR | yeet | none |
| Any visible UI completion claim | simulator-proof | ios-debugger-agent |

## Skill-combination rules

### UI work
Use:
1. garage-ui-guardian
2. swiftui-ui-patterns when implementation structure is changing
3. simulator-proof before calling the task complete

### BucketStrike work
Use:
1. bucketstrike-flow-guardian
2. garage-ui-guardian only when visual composition changes
3. simulator-proof for user-visible changes

### Refactor work
Use:
1. garage-safe-change
2. swiftui-view-refactor
3. targeted build
4. simulator-proof only if visible behavior may have changed

### Performance work
Start with:
1. swiftui-performance-audit

Escalate only when needed:
- ios-ettrace-performance for CPU/latency traces
- ios-memgraph-leaks for retained objects or memory growth

## Prompt pattern

A strong task prompt should contain:

**Goal:** one concrete outcome.

**Context:** relevant screen, file, flow, screenshot, bug, or approved visual.

**Constraints:** behavior to preserve, files or scope to avoid, architectural limits.

**Done when:** exact build, simulator, interaction, screenshot, or test proof required.

Example:

> Goal: Redesign only the BucketStrike active-practice teaching region so the full drill instruction is readable without making the screen feel denser.
>
> Context: Inspect the current active-practice view, compact drill copy adapter, tracker-mode UI, Garage theme, and nearby shared components first.
>
> Constraints: Preserve drill IDs, tracker behavior, timer/rep logic, navigation, bottom actions, and existing green/gold identity. Do not refactor the whole BucketStrike feature.
>
> Done when: The app builds, the first BucketStrike plan can reach active practice in Simulator, the revised teaching content is fully readable, tracker controls still work, and the rendered state is visually inspected.
