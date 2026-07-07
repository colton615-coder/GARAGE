# Garage Build Roadmap

Build in small, testable phases. Do not wire every visible control superficially before one complete flow works.

## Phase 0: Technical Foundation And Documentation

Goal: create repo-grounded architecture docs and protect current prototype behavior.

User-visible outcome:

- No user-facing feature change.

Main files likely involved:

- `Docs/*`

State/models required:

- None implemented.

Dependencies:

- Product Blueprint.
- Current repo inspection.

Validation criteria:

- Docs distinguish current state from target architecture.
- No Swift source behavior changes.
- Build or parse remains available for later tasks.

Wait until later:

- Any feature implementation.
- Source file reorganization.

## Phase 1: Navigation And Basic Interactions

Goal: make visible navigation affordances perform their obvious local action.

User-visible outcome:

- Home rows switch to BucketStrike, Tempo, and Colt's Caddy.
- `View Plan` routes to the relevant BucketStrike setup/plan state.
- Decorative rows either become buttons or lose misleading affordance.

Main files likely involved:

- `GarageRootView.swift`
- `GarageHomeView.swift`
- `GarageComponents.swift`

State/models required:

- Root `selectedTab` binding or callback into Home.
- Optional enum for Home action target.

Dependencies:

- Existing `GarageTab`.

Validation criteria:

- Home -> BucketStrike works.
- Home -> Tempo works.
- Home -> Colt's Caddy works.
- No tab loses its own `NavigationStack`.

Wait until later:

- Practice session persistence.
- AI.
- Tempo engine.

## Phase 2: BucketStrike Vertical Slice

Goal: build the first real vertical slice.

User-visible outcome:

```text
Home
-> BucketStrike
-> choose practice type
-> select or generate a session
-> Start Practice
-> active practice screen
-> complete session
-> save one Carry Forward cue
```

Main files likely involved:

- `BucketStrikeView.swift`
- New `BucketStrikeStore.swift`
- New BucketStrike model files
- New active session/completion subviews
- `GarageHomeView.swift` for Carry Forward display later

State/models required:

- `PracticeType`
- `PracticeFocus`
- `Drill`
- `PracticePlan`
- `PracticePlanItem`
- `PracticeSession`
- `PracticeSessionResult`
- `CarryForwardCue`

Dependencies:

- Deterministic local plan data.
- No AI dependency.

Validation criteria:

- Changing practice type updates the plan.
- Start Practice opens active session state.
- Next and Skip move through drills.
- End/Complete reaches completion.
- User can enter or select one Carry Forward cue.
- Flow survives ordinary child view redraws.

Wait until later:

- Long-term history.
- Cloud sync.
- Recommendation engine.

## Phase 3: BucketStrike Persistence And History

Goal: save the first useful user memory.

User-visible outcome:

- Completed session result is stored locally.
- One Carry Forward cue survives relaunch.
- Home shows the latest cue from real stored data.

Main files likely involved:

- BucketStrike models/store
- New persistence/repository file
- `GarageHomeView.swift`

State/models required:

- `PracticeSessionResult`
- `CarryForwardCue`

Dependencies:

- Completed in-memory BucketStrike vertical slice.

Validation criteria:

- Complete a session.
- Relaunch app.
- Latest Carry Forward cue still appears.

Wait until later:

- Rich history dashboard.
- Analytics.
- Cloud sync.

## Phase 4: Tempo Functional Engine

Goal: make Tempo a real rhythm loop.

User-visible outcome:

- BPM and ratio are real settings.
- Start begins a repeating cue loop.
- Stop returns to Ready.
- Audio and haptics settings control outputs.

Main files likely involved:

- `TempoView.swift`
- New `TempoStore.swift`
- New `TempoTimingEngine.swift`
- Optional audio/haptic cue service files

State/models required:

- `TempoSettings`
- `TempoSession`
- `TempoRunState`
- `TempoAudioMode`

Dependencies:

- Local timing implementation.
- Apple-native audio/haptics APIs only when needed.

Validation criteria:

- BPM changes affect timing.
- Ratio changes affect cue spacing.
- Audio Off suppresses sound.
- Haptics Off suppresses haptics.
- Stop cleans up timers/tasks.

Wait until later:

- Advanced profiles unless product approves them.
- Background audio.

## Phase 5: Colt's Caddy Local Conversation Shell

Goal: make the conversation UI honest and locally functional before AI.

User-visible outcome:

- User can type a message.
- Send appends the user message.
- App appends deterministic sample assistant response.
- Quick context chips set explicit local context.

Main files likely involved:

- `ColtsCaddyView.swift`
- New Caddy models/store
- New local response adapter

State/models required:

- `CaddyMessage`
- `CaddyConversation`
- `ShotContext`
- `CaddyQuickContext`

Dependencies:

- No network.
- No API key.

Validation criteria:

- Composer works above tab bar and keyboard.
- Sending empty message is prevented.
- New messages scroll naturally.
- Chips visibly affect context or draft text.

Wait until later:

- Live AI.
- Persisted conversation history.
- Course database.

## Phase 6: AI Service Boundary And Integration

Goal: add AI safely after the local conversation contract is stable.

User-visible outcome:

- Caddy can request advisory responses from an AI-backed service.
- Loading and error states are visible.
- AI never silently mutates user data.

Main files likely involved:

- Caddy service files
- Caddy models/store
- Secure configuration outside view code

State/models required:

- `CaddyRequest`
- `CaddyResponse`
- Request state enum

Dependencies:

- Approved API/provider plan.
- Secure key handling.
- Local deterministic adapter for testing.

Validation criteria:

- View layer does not own API calls or secrets.
- Service has testable request/response boundary.
- Failure state does not lose draft or conversation.

Wait until later:

- Accounts.
- Cloud sync.
- Multi-provider abstraction unless needed.
