# Codex Starter Plan

## Phase 0: Repo Inspection

Initial session inspection found:

- Working directory: `/Users/colton/Documents/Codex/2026-07-03/new-chat`
- Current folder contents before edits: `work/` and `outputs/`
- Expected prior checkout path `/Users/colton/Desktop/LIFE-IN-SYNC` was not present.
- No `.xcodeproj`, `.xcworkspace`, `Package.swift`, `Garage`, or `LIFE-IN-SYNC` project was found under the accessible search paths.

Conclusion: this was an empty/generated Codex workspace, not an existing SwiftUI app checkout. The project was intentionally created from scratch after that was confirmed.

## Phase 1: Documentation

Created starter documentation:

- `GARAGE_PRODUCT_BRIEF.md`
- `GARAGE_UI_KIT.md`
- `GARAGE_NAV_ARCHITECTURE.md`
- `GARAGE_SCREEN_SPECS.md`
- `CODEX_STARTER_PLAN.md`

These docs define the product, UI, navigation, screen specs, and next build phases.

## Phase 2: Design Tokens and Style Primitives

Completed in the scratch project with minimal SwiftUI primitives:

- `GarageTheme`
- `GarageCard`
- `GarageSectionHeader`
- `GaragePrimaryButton`
- `GarageToolRow`

No third-party packages were introduced.

## Phase 3: Bottom Tab Shell

Completed in the scratch project with a `TabView` containing:

- Home
- BucketStrike
- Tempo
- Colt's Caddy

The starter bundle identifier is `com.colton.Garage`, deployment target is iOS 17.0, and the target is iPhone-only for this prototype.

## Phase 4: Placeholder Screens

Completed with local placeholder data only. The screens establish hierarchy and navigation without pretending to have production data, AI, persistence, audio, or haptics.

## Phase 5: Screenshot Review and UI Iteration

After launching in Simulator:

1. Launch the app in Simulator.
2. Capture screenshots of all four tabs.
3. Compare against the visual direction, not as a pixel clone.
4. Fix hierarchy, spacing, contrast, tab behavior, and obvious SwiftUI layout issues.

## Build/Test Commands Available For This Session

Identify schemes:

```sh
xcodebuild -list
```

Run an unsigned simulator build for structural verification:

```sh
xcodebuild -project outputs/Garage/Garage.xcodeproj -scheme Garage -destination 'generic/platform=iOS Simulator' -derivedDataPath work/DerivedData/GarageNoSigning CODE_SIGNING_ALLOWED=NO build
```

The unsigned build is useful in this Codex desktop environment because the final local signing step can fail on file-provider/Finder metadata even when Swift compilation, assets, linking, and packaging succeed.

## Risks

- The signed simulator build can fail in this environment on `resource fork, Finder information, or similar detritus not allowed`.
- The current shell is a prototype Garage app, not yet merged into any larger LIFE-IN-SYNC architecture.
- The attached mockups were used as direction references, not exact screens.

## What Not To Add Yet

- No project settings.
- No signing settings.
- No bundle identifiers.
- No backend, login, sync, analytics, monetization, or AI API.
- No real tempo engine, audio engine, haptics, or persistence.

## Next Practical Move

Open `Garage.xcodeproj`, run the `Garage` scheme in Simulator, capture all four tabs, and do a visual pass focused on hierarchy, spacing, contrast, and native tab behavior before adding real feature logic.
