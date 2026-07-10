# Garage Product To Repo Gap Analysis

Classification key:

- EXISTS: implemented as real behavior.
- PARTIAL: some real behavior exists, but incomplete.
- UI ONLY: visual shell or static placeholder only.
- MISSING: no implementation exists.

## Gap Table

| Area | Classification | Repo evidence | Smallest next architectural step |
| --- | --- | --- | --- |
| Four-tab app shell | EXISTS | `GarageRootView` has `TabView` with Home, BucketStrike, Tempo, Colt's Caddy | Preserve; add feature-owned state without replacing shell |
| Home routing | UI ONLY | Home rows are `GarageToolRow`; `View Plan` button has empty closure | Pass tab-switch callback/binding from root into Home |
| BucketStrike practice type selection | PARTIAL | `selectedPracticeType` local `@State`; segmented `Picker` updates selection | Replace string array with `PracticeType` enum and make plan read selected type |
| Session focus selection | UI ONLY | Focus rows are static `GarageToolRow` values | Add selectable `PracticeFocus` model and store state |
| Session generation | MISSING | No plan factory, models, or generated plan state | Add deterministic `PracticePlanFactory` for local plans |
| Active practice flow | MISSING | `Start Practice` action is empty | Add BucketStrike active session state and active drill view |
| Session completion | MISSING | No completion screen or result model | Add completion state and `PracticeSessionResult` |
| Carry-forward capture | UI ONLY | Home displays static "Note from yesterday" | Add `CarryForwardCue` model and save from BucketStrike completion |
| Tempo controls | PARTIAL | BPM slider updates `bpm`; ratio/audio/haptics are static rows | Add `TempoSettings` with editable ratio/audio/haptics |
| Tempo timing engine | MISSING | No timer, task, engine, or run state | Add `TempoTimingEngine` owned by Tempo feature state |
| Tempo audio | UI ONLY | Static "Metronome" row only | Add audio mode model first, then cue player service later |
| Tempo haptics | UI ONLY | Static "On" row only | Add haptics setting first, then haptic cue service later |
| Caddy composer | UI ONLY | Composer is a `Text` placeholder plus buttons with empty actions | Replace placeholder with bound `TextField`/draft state |
| Local message sending | MISSING | Messages are static `CaddyMessage` view calls, not models | Add `CaddyMessage` model and local send action |
| Conversation state | MISSING | No messages array or conversation store | Add `CaddyConversationStore` |
| Shot/course context | UI ONLY | `HoleContextCard` hard-codes hole, wind, elevation | Add `ShotContext` model and explicit context state |
| AI integration | MISSING | No networking, service, request, or provider code | Add service boundary only after local shell works |
| Persistence | MISSING | No SwiftData, Core Data, UserDefaults, AppStorage, or file storage | Persist first Carry Forward cue and Tempo settings after in-memory flows |
| History | MISSING | No history models, screens, or storage | Persist `PracticeSessionResult` after completion flow works |

## Product Blueprint Alignment

The repository matches the blueprint's visual and structural starting point:

- Four-tab shell exists.
- Dark restrained visual direction exists.
- Home, BucketStrike, Tempo, and Colt's Caddy screens exist.
- Current UI protects the concept of separate feature lanes.

The repository does not yet match the blueprint's functional goals:

- BucketStrike is not a usable practice flow.
- Tempo is not a rhythm engine.
- Colt's Caddy is not a working conversation.
- No user data survives app relaunch.

## Highest Priority Gap

The largest gap is BucketStrike vertical-slice functionality. The blueprint names BucketStrike as the first serious implementation target, but the repo currently has only a segmented picker, static focus rows, a static plan card, and an empty Start Practice action.

## Recommended First Gap Closure

Implement Home-to-BucketStrike routing and a deterministic BucketStrike plan update:

1. Pass tab selection into Home.
2. Make Home's BucketStrike row switch to BucketStrike.
3. Replace BucketStrike string practice types with a `PracticeType` enum.
4. Add deterministic plan content that changes when practice type changes.

This is smaller than the full active-session vertical slice and prepares the state boundary for it.

## Gaps That Need Product Decisions

- Whether BucketStrike focus is user-selected, deterministic, recommended, or hybrid.
- Whether completion reflection is cue-only, quality rating only, or both.
- Whether Tempo v1 needs named profiles.
- How much editable shot context Caddy exposes before AI.
- Which data must persist first beyond Tempo settings and Carry Forward cue.
