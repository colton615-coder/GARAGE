# Garage State Ownership Map

This document maps current state ownership and recommended future ownership.

## Current State

| State | Current owner | Current lifetime | Current behavior |
| --- | --- | --- | --- |
| Selected tab | `GarageRootView.selectedTab` | In-memory while root view lives | Drives `TabView` selection |
| Selected practice type | `BucketStrikeView.selectedPracticeType` | In-memory while view lives | Picker selection only; plan does not change |
| BPM | `TempoView.bpm` | In-memory while view lives | Slider updates dial and BPM row |

No other real state exists. Most visible values are hard-coded strings.

## Recommended Ownership

### Global/App

| State | Current owner | Recommended owner | Persistence lifetime | Views may read | Views may mutate |
| --- | --- | --- | --- | --- | --- |
| Selected tab | `GarageRootView` | `GarageRootView` | Transient | Root, Home through binding/callback | Root; Home through explicit tab switch callback |
| App-level preferences | Missing | Small app settings store only if needed | Persisted only for real app-wide settings | Root and relevant features | Settings UI only |

Notes:

- Do not create a giant global app state for feature internals.
- Home may switch tabs but should not own tab selection.

### BucketStrike

| State | Current owner | Recommended owner | Persistence lifetime | Views may read | Views may mutate |
| --- | --- | --- | --- | --- | --- |
| Selected practice type | `BucketStrikeView` local `@State` | `BucketStrikeStore` once plan generation exists | Persist preferred type later; current selection can be transient | BucketStrike setup, plan view | BucketStrike setup controls |
| Selected session focus | Missing | `BucketStrikeStore` | Transient during setup; optionally persist recent focus later | Setup and plan views | Focus selection UI |
| Generated session plan | Static copy in `BucketStrikeView` | `PracticePlanFactory` result stored in `BucketStrikeStore` | Transient until session starts; completed plan snapshot persisted with session | Plan and active session views | Store only, via deterministic generation |
| Active practice session | Missing | `BucketStrikeStore` | Transient while active; persist result on completion | Active practice and completion views | Store through explicit intents |
| Current drill index | Missing | `BucketStrikeStore` | Transient during active session | Active practice view | Next, Skip, Back actions |
| Session completion state | Missing | `BucketStrikeStore` | Persist completed session result | Completion view, Home summary after save | Completion actions |
| Carry Forward cue | Static Home copy | `CarryForwardCue` persisted through BucketStrike completion | Persisted | Home, BucketStrike completion/history | Completion/edit cue UI |
| Session quality/reflection | Missing | `PracticeSessionResult` | Persisted with session result if product chooses it | Completion and history views | Completion UI |

Recommendation:

- Start with one `BucketStrikeStore` for the vertical slice.
- Use value models for plans and sessions.
- Persist only after the in-memory flow works.

### Tempo

| State | Current owner | Recommended owner | Persistence lifetime | Views may read | Views may mutate |
| --- | --- | --- | --- | --- | --- |
| BPM | `TempoView.bpm` local `@State` | `TempoStore` or `TempoSettings` binding | Persisted P1 | Tempo ready/active UI, timing engine | BPM controls |
| Ratio | Static label | `TempoSettings` | Persisted P1 | Tempo UI, timing engine | Ratio controls |
| Audio mode | Static label | `TempoSettings` | Persisted P1 | Tempo UI, audio cue service | Audio setting UI |
| Haptics enabled | Static label | `TempoSettings` | Persisted P1 | Tempo UI, haptic cue service | Haptics setting UI |
| Ready/active/paused state | Missing | `TempoStore` | Transient run state | Tempo UI | Start, pause, resume, stop actions |
| Timing engine ownership | Missing | `TempoStore` owns engine lifecycle, or engine injected into store | Transient engine; persisted settings only | Store and Tempo UI via published cues | Store only |

Recommendation:

- Keep precise cue timing outside the SwiftUI view body.
- UI should read current phase/cue state and send start/stop intents.

### Colt's Caddy

| State | Current owner | Recommended owner | Persistence lifetime | Views may read | Views may mutate |
| --- | --- | --- | --- | --- | --- |
| Conversation messages | Static view copy | `CaddyConversationStore` | Transient for v1 shell; persistence P2 after behavior stabilizes | Caddy conversation view | Send response flow only |
| Current input | Missing, visual `Text` only | `CaddyConversationStore.draft` or local `@State` promoted later | Transient | Composer | Composer input |
| Active shot/course context | Static `HoleContextCard` copy | `ShotContext` in `CaddyConversationStore` | Transient first; persisted only if product wants recent context | Context card, request builder | Context edit UI/chips |
| Quick context selections | Static labels | `CaddyQuickContext` selection in store | Transient | Chips and composer/request builder | Chip buttons |
| Future AI request state | Missing | `CaddyConversationStore` | Transient request state; messages may persist later | Caddy view | Store when send action starts/completes |

Recommendation:

- Start with local deterministic send behavior before AI.
- Keep prompt construction and API calls out of `ColtsCaddyView`.
- Do not persist Caddy history until the product behavior is stable.

## Transient vs Persisted

### Should remain transient at first

- Current tab selection.
- BucketStrike setup selections until a plan/session is started.
- Active Tempo run state.
- Caddy draft input.
- Caddy loading/error request state.
- Caddy quick context selections.

### Should be persisted first

- Tempo BPM, ratio, audio mode, haptics setting.
- Completed BucketStrike session results.
- One Carry Forward cue from session completion.

### Should wait

- Caddy conversation history.
- Player club distance profile.
- Rich practice history analytics.
- AI request/response audit trail.
