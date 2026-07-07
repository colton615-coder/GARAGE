# Garage Navigation Map

This document separates current navigation from recommended target navigation.

## Current Navigation

Current root:

```text
GarageApp
-> GarageRootView
-> TabView
   -> Home NavigationStack -> GarageHomeView
   -> BucketStrike NavigationStack -> BucketStrikeView
   -> Tempo NavigationStack -> TempoView
   -> Colt's Caddy NavigationStack -> ColtsCaddyView
```

Current behavior:

- Native tab bar switches tabs.
- Each tab is wrapped in a `NavigationStack`.
- No tab currently pushes another screen.
- No sheets or full-screen covers exist.
- Home rows do not switch tabs.
- Buttons are mostly empty closures.

## Recommended Target Navigation

### Home

Current:

```text
Home
```

Target:

```text
Home
-> switch to BucketStrike
-> switch to Tempo
-> switch to Colt's Caddy
```

Future Home detail:

```text
Home
-> Carry Forward cue summary
-> read/edit cue
-> Home
```

Implementation note:

- Pass Home a tab-switch callback or `Binding<GarageTab>`.
- Home should not own feature internals.

### BucketStrike

Current:

```text
BucketStrike
-> Practice Type picker changes local selectedPracticeType
```

Target vertical slice:

```text
BucketStrike
-> Practice Type
-> Session Focus
-> Session Plan
-> Start Practice
-> Active Practice Session
-> Drill Progression
-> Session Complete
-> Carry Forward
-> Home summary updates later
```

More detailed target:

```text
BucketStrike Ready
-> choose Practice Type
-> select or accept Session Focus
-> generated Practice Plan visible
-> Start Practice
-> Active Drill 1
-> Next or Skip
-> Active Drill N
-> End Session
-> Completion Reflection
-> Save Carry Forward
-> BucketStrike Ready or Home
```

Recommended presentation:

- Start with in-place enum state inside BucketStrike for setup/plan/active/completion.
- Use push navigation only when active session or history needs its own screen.
- Do not use Home as part of the flow.

### Tempo

Current:

```text
Tempo
-> BPM slider updates local BPM
```

Target:

```text
Tempo Ready
-> Start
-> Active
-> Pause
-> Resume
-> Stop
-> Ready
```

Settings and quick adjustments:

```text
Tempo Ready
-> adjust BPM
-> adjust Ratio
-> choose Audio mode
-> toggle Haptics
-> Start
```

Future settings presentation:

```text
Tempo
-> BPM inline control
-> Ratio sheet or inline selector
-> Audio mode sheet
-> Haptics inline toggle
```

Implementation note:

- The timing engine should read the same `TempoSettings` that the UI renders.
- Audio Off and Haptics Off must suppress their respective outputs.

### Colt's Caddy

Current:

```text
Colt's Caddy
-> static conversation
-> static context
-> visual composer
```

Target local shell:

```text
Caddy Conversation
-> enter question
-> attach/update context
-> send
-> deterministic local response
-> continue conversation
```

Future AI flow:

```text
Caddy Conversation
-> enter question
-> edit explicit ShotContext
-> send
-> CaddyResponseService request
-> loading
-> response or error
-> continue conversation
```

Context editing:

```text
Caddy Conversation
-> tap context card or quick chip
-> context editor sheet
-> save explicit context
-> Caddy Conversation
```

Implementation note:

- Keep composer in `safeAreaInset`.
- Add real `TextField` or `TextEditor` input before message sending.
- Use `ScrollViewReader` later to keep the newest message reachable.

## Future Navigation Mentioned In Blueprint But Missing Today

Missing destinations:

- BucketStrike active practice screen.
- BucketStrike drill progression screen/state.
- BucketStrike completion/reflection screen.
- Carry Forward read/edit view.
- Tempo active rhythm screen/state.
- Tempo pause/resume/stop controls.
- Tempo audio mode selector.
- Tempo ratio selector.
- Caddy context editor.
- Caddy local send/response state.
- Caddy AI loading/error states.
- Practice history.

Do not pretend these exist. Add them one vertical slice at a time.
