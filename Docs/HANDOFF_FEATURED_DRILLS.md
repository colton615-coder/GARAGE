# Handoff: `featured` Flag — Curated 8-Drill BucketStrike Roster

**Date:** 2026-07-09
**Status:** Complete. Build green, 17/17 tests passing, runtime-verified across all 4 environments.

## What changed and why

BucketStrike's active roster was reduced from 20 drills to 8 curated drills (roughly 2 per environment) **without deleting any drill content**. All 20 drills remain in `drills.json` and remain valid. The 12 non-featured drills are dormant: never generated into a plan, never shown in any UI surface, but fully preserved and re-activatable by flipping a single boolean in JSON.

The `featured` flag in `drills.json` is the **single source of truth** for what's active. There is no hardcoded ID list in Swift.

## The 8 featured drills

| ID | Environments |
|---|---|
| `towel-behind` | range, net |
| `toe-heel-gate` | range, net |
| `feet-together-balance` | range, net |
| `carry-ladder` | range, shortGame |
| `lead-hand-only` | shortGame, net |
| `landing-spot-towel` | shortGame |
| `start-line-gate` | puttingGreen |
| `clock-circle` | puttingGreen |

The 12 dormant drills: `driver-gate`, `three-and-switch`, `trajectory-three-ways`, `roll-out-ratios`, `splash-line`, `bunker-ladder`, `distance-ladder`, `par-18`, `nine-shot-range`, `two-ball-takeaway`, `continuous-swings`, `circle-your-foot`.

## Files changed

### 1. `Garage/Screens/BucketStrike/DrillLibrary.swift`

- `Drill` gained `var featured: Bool = false`. Declared as a defaulted `var` (not `let`) so the memberwise initializer keeps working without a `featured:` argument — `PracticePlanValidatorTests` builds `Drill` fixtures with that initializer.
- Custom `init(from decoder:)` was added in an extension (keeps the memberwise init available). Every existing field decodes as before; `featured` uses `decodeIfPresent(...) ?? false`, so the key is **optional in JSON and non-breaking** — any drill entry without it decodes as dormant.
- `DrillLibrary` gained `var featuredDrills: [Drill]` (`allDrills.filter(\.featured)`).
- Both serving queries — `drills(environment:)` and `drills(environment:focus:)` — now filter from `featuredDrills` instead of `allDrills`. These two methods are the **only** path by which drills reach `PracticePlanFactory` and therefore the UI, so filtering here covers every surface.
- `allDrills` still exposes the full 20-drill library (used by validation/tests).

### 2. `Garage/Screens/BucketStrike/drills.json`

- Every drill entry got an explicit `"featured": true` (the 8 above) or `"featured": false` (the other 12), inserted directly after the `"id"` line.
- **No other drill data was modified** — names, environments, focuses, steps, visual concepts, etc. are byte-identical.

### 3. `GarageTests/BucketStrike/DrillLibraryFeaturedTests.swift` (new)

Five tests:

- `fullLibraryStillContainsAllTwentyDrills` — `allDrills.count == 20` (protects against accidental deletion).
- `exactlyEightDrillsAreFeatured` — `featuredDrills.count == 8`.
- `everyEnvironmentHasAtLeastOneFeaturedDrill` — all 4 `PracticeEnvironment` cases have featured coverage.
- `environmentDrillQueriesServeOnlyFeaturedDrills` — both library query methods return only featured drills, for every environment × focus.
- `generatedPlansContainOnlyFeaturedDrills` — every selectable practice-type × focus combo produces a plan whose drills are all featured.

The test target uses a file-system-synchronized group, so the new file was picked up without a pbxproj edit.

## What was deliberately NOT touched

- **Visual profiles** (`BucketStrikeDrillCatalogs.swift`): `BucketDrillVisualProfileCatalog` and its `validate()` still assert 20 profiles / 20 unique mapped drill IDs. Those assertions are intact and correct, because all 20 drills still exist. Dormant drills keep their profiles for when they're reactivated.
- **`visualConfig` / drill visuals** — unchanged.
- **Batch-entry active-practice flow** and the **Edit Plan fix** — unchanged.
- `PracticePlan.swift`, `PracticePlanValidator.swift`, `PracticePlanFactory.swift` — unchanged. The factory automatically only sees featured drills because its inputs are the two filtered library queries.

## Test results

- **17/17 passing**: 12 pre-existing (3 factory tests, 8 validator tests, 1 placeholder) + 5 new featured tests.
- Existing 20-count assertions were not weakened: `validate()`'s 20-profile/20-mapped-ID asserts are untouched, and the new `allDrills.count == 20` test adds explicit coverage of the drill total.
- One compile note for posterity: `allSatisfy(\.featured)` (key path as function) inside a Swift Testing `#expect` macro fails to build ("call can throw, but not marked with try" in macro-generated code). Use explicit closures (`allSatisfy { $0.featured }`) inside `#expect`.

## Runtime verification

Verified via `RunCodeSnippet` in the app's runtime context (bundled `drills.json`), exercising `BucketPracticePlan.makeDisplayPlan(practiceType:focus:)` — the exact code path that feeds session start, the plan preview, and the Edit Plan sheet — for all 12 practice-type × focus combos:

| Environment | Focus → drills served |
|---|---|
| Range | Direction → carry-ladder · Contact → toe-heel-gate, towel-behind · Tempo → feet-together-balance |
| Net | Contact → lead-hand-only, toe-heel-gate, towel-behind · Tempo → feet-together-balance · Scoring → feet-together-balance |
| Short Game | Contact → lead-hand-only · Distance → carry-ladder, landing-spot-towel · Scoring → carry-ladder |
| Putting | Direction → start-line-gate · Distance → start-line-gate · Scoring → clock-circle |

- Zero non-featured drills appeared in any plan; all 12 dormant drills surfaced nowhere.
- The Edit Plan sheet (`BucketStrikePlanEditingView`) only reorders/removes drills already in the generated plan — it has **no library browser** — so there is no other UI surface that can reach a dormant drill.
- This was verified by executing the serving path directly, not by tapping through the simulator UI; the UI renders these plans verbatim (`previewPlan` → `curatedPlan` → `makeDisplayPlan`).

## Behavior notes / known consequences

Some environment+focus combos lost their only focus-matching drill to dormancy and now serve **backfill** drills (featured drills from the same environment that don't match the focus). `PracticePlanValidator` explicitly permits backfills (`isBackfill == true` skips the focus check), so plans stay valid — this mirrors pre-existing behavior for Net+Scoring, which never had a focus match.

Affected combos:

- **Range + Direction**: lost `driver-gate` → serves `carry-ladder` (backfill).
- **Putting + Distance**: lost `distance-ladder` → serves `start-line-gate` (backfill).
- **Short Game + Scoring**: lost `par-18` → serves `carry-ladder` (backfill).

If those pairings feel wrong in the product, the fix is data-side: feature a drill that matches the focus (e.g. re-feature `distance-ladder` for putting distance) — no Swift change needed.

## How to reactivate a drill

Flip its flag in `Garage/Screens/BucketStrike/drills.json`:

```json
"featured": true
```

Nothing else is required — the library, factory, UI, and visual profile mapping all pick it up. If the featured count changes, update `exactlyEightDrillsAreFeatured` in `DrillLibraryFeaturedTests.swift` to the new expected count.
