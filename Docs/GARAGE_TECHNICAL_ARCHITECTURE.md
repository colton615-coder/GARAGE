# Garage Technical Architecture

This is the recommended architecture for evolving the current SwiftUI prototype into a real app. It is based on the current repository and the product intent in `Garage_Product_Blueprint_v1.docx`.

## Architecture Goals

- SwiftUI-first.
- Apple-native.
- Dependency-light.
- Local-first where practical.
- Beginner-readable.
- Safe for small Codex implementation tasks.
- Modular without adding architecture frameworks.

Do not introduce Redux-style global state, a giant all-purpose `AppState`, broad protocols for every type, or a dependency injection framework.

## Recommended Folder Shape

Current folder shape should be extended gradually:

```text
Garage/
  App/
  DesignSystem/
  Models/
  Services/
  Persistence/
  SharedUI/
  Screens/
    Home/
    BucketStrike/
    Tempo/
    ColtsCaddy/
```

This structure is a target. Do not move existing files just to match it. Add folders only when a real implementation needs them.

## App Layer

Current files:

- `GarageApp.swift`
- `GarageRootView.swift`

Recommended responsibilities:

- Own app launch.
- Own root tab selection.
- Install shared environment dependencies once they exist.
- Keep one `NavigationStack` per tab.
- Coordinate cross-tab routing from Home by passing a `Binding<GarageTab>` or a small tab-selection closure.

Recommended near-term shape:

- Keep `GarageRootView` as the tab shell.
- Keep `GarageTab` as the root tab enum.
- Add `@State` or `@StateObject` feature stores only when features need durable state across child view redraws.
- Avoid a global router until a feature has more than one pushed destination.

What the app layer must not own:

- Drill generation details.
- Active BucketStrike session internals.
- Tempo timing loop.
- Caddy message composition.
- AI request construction.

## Feature Boundaries

### Home

Current file:

- `GarageHomeView.swift`

Owns:

- Summary layout.
- Today's Focus display.
- Tool entry rows.
- Carry Forward summary presentation.

May read:

- Latest Carry Forward cue.
- Recommended next action.
- Tab selection action from root.

Must not own:

- BucketStrike session state.
- Tempo engine state.
- Caddy conversation state.

Likely future state:

- `HomeSummary` value model.
- Optional `CarryForwardCue`.
- A selected/recommended `GarageTab` or route intent.

Likely services:

- A lightweight summary provider that reads persisted practice memory once persistence exists.

Navigation responsibility:

- Switch tabs or open simple summary/edit destinations.
- Do not duplicate full feature workflows.

### BucketStrike

Current file:

- `BucketStrikeView.swift`

Owns:

- Practice setup.
- Session plan review.
- Active practice session.
- Drill progression.
- Session completion.
- Carry Forward capture.

May read:

- Persisted preferred practice type.
- Recent Carry Forward cue.
- Deterministic drill templates.

Must not own:

- Global app tab state beyond receiving navigation callbacks.
- Tempo engine.
- Caddy conversation.
- AI provider integration for v1 plan generation.

Likely models:

- `PracticeType`
- `PracticeFocus`
- `Drill`
- `PracticePlan`
- `PracticePlanItem`
- `PracticeSession`
- `PracticeSessionResult`
- `CarryForwardCue`

Likely feature state:

- `BucketStrikeStore` or `BucketStrikeSessionState` once flow exceeds local setup state.
- Selected practice type.
- Selected focus.
- Generated deterministic plan.
- Active session.
- Current drill index.
- Completion/reflection state.

Likely services:

- `PracticePlanFactory` for deterministic local plans.
- `PracticeSessionRepository` later for persistence.

Navigation responsibility:

- Setup -> plan -> active session -> completion.
- Keep this within BucketStrike using local enum state, a tab-local `NavigationStack`, or a sheet only when the presentation is temporary.

### Tempo

Current file:

- `TempoView.swift`

Owns:

- BPM.
- Ratio.
- Audio mode.
- Haptics preference.
- Tempo session state.
- Timing engine lifecycle.

May read:

- Persisted tempo settings.
- App-level audio/haptic permissions only if needed.

Must not own:

- Practice plan generation.
- BucketStrike session history.
- Caddy conversation or AI state.

Likely models:

- `TempoSettings`
- `TempoSession`
- `TempoRatio`
- `TempoAudioMode`
- `TempoRunState`

Likely feature state:

- `TempoStore` for settings and run state.
- `TempoTimingEngine` as a service-like object that emits cues without heavy UI redraw coupling.

Likely services:

- `TempoTimingEngine`
- `TempoAudioCuePlayer`
- `TempoHapticCuePlayer`
- `TempoSettingsRepository`

Navigation responsibility:

- Ready -> Active -> Paused/Stopped.
- Settings rows may open lightweight sheets later.

### Colt's Caddy

Current file:

- `ColtsCaddyView.swift`

Owns:

- Conversation display.
- Composer input.
- Explicit shot/course context.
- Quick context chips.
- Local deterministic response shell before AI.

May read:

- Player profile or club distances later.
- Explicit shot context selected by the user.

Must not own:

- API keys.
- Provider-specific networking.
- Hidden prompt construction inside the view body.
- Practice history mutation without visible user action.

Likely models:

- `CaddyMessage`
- `CaddyConversation`
- `ShotContext`
- `CaddyQuickContext`
- `CaddyRequest`
- `CaddyResponse`

Likely feature state:

- `CaddyConversationStore`
- Messages.
- Draft input.
- Active shot context.
- Request state: idle/loading/succeeded/failed.

Likely services:

- `CaddyResponseService` protocol only when there is a deterministic adapter and an AI adapter to swap.
- `LocalCaddyResponseService` for v1 shell.
- `AICaddyResponseService` later.

Navigation responsibility:

- Keep the conversation as the primary screen.
- Use sheets for editing shot context.
- Keep composer in `safeAreaInset` above the keyboard.

## Shared Layers

### DesignSystem

Current files:

- `GarageTheme.swift`
- `GarageComponents.swift`

Recommended ownership:

- Colors.
- Typography decisions.
- Spacing.
- Shared row, card, header, button, and icon components.

Must not own:

- Feature state.
- Routing.
- Services.
- Persistence.

Future split when needed:

- `GarageTheme.swift`
- `GarageScreen.swift`
- `GarageButtons.swift`
- `GarageRows.swift`

Only split when files become hard to read.

### Models

Recommended ownership:

- Small Swift value types and enums.
- Codable where persistence or export is needed.
- Identifiable where lists need stable identity.

Default choice:

- Use structs and enums for domain data.
- Use reference types only for stateful stores or engine objects.

### Services

Recommended ownership:

- Deterministic plan generation.
- Tempo timing/audio/haptics engines.
- Caddy response adapters.

Rules:

- Add protocols only where testing or provider substitution is real.
- Keep service APIs small and feature-specific.
- Do not create a generic networking layer before networking exists.

### Persistence

Recommended ownership:

- Store user preferences and history behind feature repositories.
- Start with lightweight local persistence.
- Do not scatter `UserDefaults` or file reads through views.

Likely first persistence:

- Tempo settings via `@AppStorage` or a small settings repository.
- Carry Forward cue and completed practice sessions via a local repository.

Choose SwiftData only when relationships and history justify it. Do not add it solely for one preference value.

### Feature State

Recommended ownership:

- Local `@State` for view-only controls.
- `@Observable` or `ObservableObject` stores for flows that must survive child redraws.
- Root-owned feature stores only when state must persist across tab switches.

Avoid:

- One global `AppState`.
- Feature state split across many child views without a single owner.

### Shared UI Components

Recommended ownership:

- Components that render state and emit user intents.
- Components should not load data, save data, or mutate unrelated state.

## First Architecture Decision Before Implementation

Before building BucketStrike, decide where the active practice session lives.

Recommended answer: a BucketStrike-owned feature store should own the selected practice type, generated plan, active session, current drill index, and completion state. Views should render the store and send intents such as `selectPracticeType`, `startSession`, `advanceDrill`, `skipDrill`, and `completeSession`.

This prevents the first real vertical slice from becoming scattered local `@State`.
