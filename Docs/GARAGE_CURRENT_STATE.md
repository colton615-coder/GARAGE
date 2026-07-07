# Garage Current State

This document describes the repository as it exists now. It separates current code from product intent in `Garage_Product_Blueprint_v1.docx`.

## Project Structure

Current root: `/Users/colton/Documents/Codex/2026-07-03/new-chat/outputs/Garage`

Important folders:

- `Garage.xcodeproj`: single Xcode project.
- `Garage/App`: app entry point and root tab shell.
- `Garage/DesignSystem`: shared theme tokens and reusable SwiftUI components.
- `Garage/Screens/Home`: Home tab view.
- `Garage/Screens/BucketStrike`: BucketStrike tab view.
- `Garage/Screens/Tempo`: Tempo tab view.
- `Garage/Screens/ColtsCaddy`: Colt's Caddy tab view.
- `Garage/Assets.xcassets`: default asset catalog and accent color.
- `Docs`: starter product, navigation, screen, and UI kit docs.
- `Screenshots`: prototype screenshots.

There are no `Tests`, `UITests`, Swift packages, workspaces, model folders, services folders, persistence folders, audio folders, or haptics folders in the current repo.

## Project Configuration

`Garage.xcodeproj/project.pbxproj` defines one target:

- Target: `Garage`
- Scheme: `Garage`
- Bundle identifier: `com.colton.Garage`
- Deployment target: iOS `17.0`
- Swift version: `5.0`
- Targeted device family: `1` (iPhone)
- Generated Info.plist: enabled

## App Entry Point

`Garage/App/GarageApp.swift` contains:

- `@main struct GarageApp: App`
- `WindowGroup { GarageRootView() }`

No app-level environment objects, services, persistence containers, launch state, or dependency injection are configured.

## Root Navigation Behavior

`Garage/App/GarageRootView.swift` owns root tab selection:

- `enum GarageTab: String, CaseIterable, Identifiable`
- Cases: `.home`, `.bucketStrike`, `.tempo`, `.coltsCaddy`
- `@State private var selectedTab: GarageTab = .home`
- `TabView(selection: $selectedTab)`
- One `NavigationStack` per tab
- `.preferredColorScheme(.dark)`
- `.dynamicTypeSize(.small ... .xxLarge)`

The app currently uses native `TabView` tab items, not a custom drawn tab bar. There is no `NavigationPath`, enum route stack, deep linking, sheet routing, or tab reselection behavior.

## Shared UI Infrastructure

`Garage/DesignSystem/GarageTheme.swift` defines static visual tokens:

- Dark background and panel colors
- Subtle border and divider colors
- Secondary text color
- Blue and green accent colors
- Page padding
- Card radius
- Page top padding
- Bottom scroll clearance values

`Garage/DesignSystem/GarageComponents.swift` defines:

- `GarageScreen`: vertical `ScrollView` wrapper with horizontal, top, and bottom padding.
- `GarageHeader`: title, subtitle, optional trailing symbol.
- `GarageSectionHeader`: uppercase section label.
- `GarageCard`: rounded panel wrapper.
- `GarageIcon`: SF Symbol tile.
- `GaragePrimaryButton`: full-width prominent action.
- `GarageToolRow`: row surface with icon, title, subtitle, and chevron.
- `GarageSettingRow`: settings row with icon, label, value, and chevron.

The shared UI is styling-focused. It does not own app state, data loading, routing, persistence, or services.

## Home Tab

File: `Garage/Screens/Home/GarageHomeView.swift`

Current status: UI-only shell.

Current sections:

- Header: "Garage"
- Today's Focus card: "Tempo Control"
- Training Tools rows: BucketStrike, Tempo, Colt's Caddy
- Carry Forward row: "Note from yesterday"

Functional interactions:

- None beyond native tab selection.

Decorative or non-functional controls:

- `View Plan` button has `Button(action: {})`.
- `GarageToolRow` rows are not buttons and do not switch tabs.
- Carry Forward row is static sample copy and not editable.

State ownership:

- No local state.
- No bindings into root tab selection.

## BucketStrike Tab

File: `Garage/Screens/BucketStrike/BucketStrikeView.swift`

Current status: partial local UI state plus static plan content.

Current state:

- `@State private var selectedPracticeType = "Range"`

Current UI:

- Header
- Segmented `Picker` with `Range`, `Net`, `Short Game`, `Putting`
- Static session focus rows:
  - Start Line Ladder
  - Contact Window
  - Scoring Finish
- Static plan summary card: "30-minute range session"
- Primary button: "Start Practice"

Functional interactions:

- Practice Type picker changes `selectedPracticeType`.

Partial implementation:

- The picker is real SwiftUI state, but changing it does not update focus rows, plan title, drills, or session summary.

Decorative or non-functional controls:

- Focus rows are not selectable.
- `Start Practice` button has `action: {}`.
- No active practice screen.
- No session progression.
- No completion or Carry Forward capture.

## Tempo Tab

File: `Garage/Screens/Tempo/TempoView.swift`

Current status: partial local UI state plus static settings rows.

Current state:

- `@State private var bpm = 72.0`

Current UI:

- Header
- `TempoDialView(bpm:)`
- Settings card:
  - BPM reads current `bpm`
  - Ratio is static `3.0:1`
  - Audio is static `Metronome`
  - Haptics is static `On`
- Slider for BPM `45...120`
- Primary button: "Start Session"

Functional interactions:

- Slider changes `bpm`.
- Dial and BPM row read the same local `bpm` value.

Partial implementation:

- BPM is real local UI state.

Decorative or non-functional controls:

- Ratio is not editable.
- Audio mode is not editable.
- Haptics setting is not editable.
- `Start Session` button has `action: {}`.
- No timing engine, audio engine, haptic engine, pause, resume, or stop state.

## Colt's Caddy Tab

File: `Garage/Screens/ColtsCaddy/ColtsCaddyView.swift`

Current status: UI-only conversation shell.

Current UI:

- Header
- `HoleContextCard` with static hole, wind, elevation, and distance copy
- Static conversation:
  - Assistant context message
  - User question
  - Assistant recommendation
- Horizontal `PromptChipRow`
- Bottom `CaddyInputBar` attached with `.safeAreaInset(edge: .bottom)`

Functional interactions:

- None.

Decorative or non-functional controls:

- Plus button has `action: {}`.
- Send button has `action: {}`.
- Input is `Text`, not `TextField`.
- Prompt chips are labels, not buttons.
- Messages are static, not model-backed.

Keyboard and safe area:

- The composer is outside scroll content via `safeAreaInset`, which is the correct direction for keyboard/input behavior.
- There is no `@FocusState`, text input, keyboard dismissal policy, or scroll-to-bottom behavior yet.

## Existing Models

No app model types exist in the current source.

Current data is represented by:

- String arrays inside views, such as `practiceTypes`.
- Hard-coded copy in view bodies.
- Static enum `GarageTab`.
- Static design tokens in `GarageTheme`.

## Existing Observable and State Types

Current state is only local SwiftUI `@State`:

| State | Owner | Purpose |
| --- | --- | --- |
| `selectedTab` | `GarageRootView` | Native tab selection |
| `selectedPracticeType` | `BucketStrikeView` | Segmented picker selection |
| `bpm` | `TempoView` | Slider and dial value |

There is no `@StateObject`, `@ObservedObject`, `@EnvironmentObject`, `@Observable`, `ObservableObject`, actor, store, repository, or service object.

## Mock and Sample Data

All feature content is hard-coded in SwiftUI views:

- Home's Today Focus and Carry Forward copy.
- BucketStrike drills and plan summary.
- Tempo ratio, audio, and haptic settings.
- Caddy hole context, prompt chips, messages, and timestamps.

The prototype does not currently mark this sample content in-app. It should be treated as deterministic sample data, not live intelligence.

## Persistence Status

There is no persistence implementation:

- No SwiftData.
- No Core Data.
- No `UserDefaults` or `@AppStorage`.
- No file storage.
- No persisted practice history.
- No persisted tempo settings.
- No persisted Caddy conversations.

## Service Layer Status

There are no service types or service boundaries.

Missing service areas include:

- Practice plan generation.
- Practice session lifecycle.
- Tempo timing.
- Audio playback.
- Haptic feedback.
- Caddy response generation.
- AI provider boundary.
- Persistence/repository boundary.

## Audio, Haptics, Timer, and Networking Status

Search results show:

- No `Timer`.
- No async/await.
- No actors.
- No `URLSession`.
- No AVFoundation or audio code.
- No Core Haptics or UIKit feedback generator usage.

Tempo audio and haptics rows are labels only.

## Tests

No test target or test source files are present in the repository. `Garage.xcodeproj` has one app target only.

## Previews

Each primary view has a `#Preview`:

- `GarageRootView`
- `GarageHomeView`
- `BucketStrikeView`
- `TempoView`
- `ColtsCaddyView`

Previews use the production view directly. There are no preview fixtures or mock services.

## Known Architectural Risks

- UI controls look actionable before behavior exists.
- Feature state is local to views and will reset on view recreation.
- There are no model boundaries, so future implementation could drift into hard-coded view logic.
- Home cannot route to tabs because it does not receive or mutate `selectedTab`.
- BucketStrike has no durable session state, so an active session would be fragile if added directly inside child views.
- Tempo has no separation between timing engine and UI redraws.
- Colt's Caddy has no message model, input state, or service boundary, so AI could be added in the wrong layer if not planned first.
- No tests exist to protect future vertical slices.

## Technical Debt Already Visible

- Static strings are embedded in view bodies.
- `GarageToolRow` visually suggests navigation but is not interactive.
- `GaragePrimaryButton` instances are wired to empty closures.
- Caddy composer is a visual placeholder, not a text input.
- Tempo setting rows look tappable due to chevrons but do not open settings.
- There is no documented state ownership beyond starter navigation docs.
