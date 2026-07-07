# Garage Data Model Plan

This is a minimum model plan for the Product Blueprint and near-term roadmap. No models are implemented in the current repository.

Default rule: use Swift value types (`struct` and `enum`) for domain data. Use reference types only for state stores, engines, or services with lifecycle.

## BucketStrike Models

### PracticeType

Purpose: represent the practice environment.

Type: enum.

Important fields/cases:

- `range`
- `net`
- `shortGame`
- `putting`
- `title`
- `symbolName`

Persistence: persist preferred type later; current selection can be transient.

Relationships:

- Used by `PracticePlanFactory` to generate a `PracticePlan`.
- Stored on `PracticeSession`.

### PracticeFocus

Purpose: represent a user's session intent or focus area.

Type: struct or enum. Start with enum if the list is fixed.

Important fields:

- `id`
- `title`
- `subtitle`
- `symbolName`
- `practiceTypes`

Persistence: transient during setup; optional recent focus later.

Relationships:

- Selected before generating a plan.
- May influence drill selection.

### Drill

Purpose: define one executable practice block.

Type: struct.

Important fields:

- `id`
- `title`
- `setup`
- `cue`
- `targetDescription`
- `repTarget`
- `durationSeconds`
- `symbolName`
- `accentKind`

Persistence: static template data can remain bundled; session snapshots can persist selected drills.

Relationships:

- Referenced by `PracticePlanItem`.
- Rendered in active practice.

### PracticePlan

Purpose: describe a generated or selected practice plan before it starts.

Type: struct.

Important fields:

- `id`
- `practiceType`
- `title`
- `subtitle`
- `estimatedMinutes`
- `intent`
- `items`

Persistence: transient until a session starts; optionally persist recent plans later.

Relationships:

- Contains ordered `PracticePlanItem` values.
- Becomes the basis for `PracticeSession`.

### PracticePlanItem

Purpose: represent a drill in a plan with ordering and plan-specific targets.

Type: struct.

Important fields:

- `id`
- `drill`
- `order`
- `repTarget`
- `durationSeconds`
- `notes`

Persistence: persisted as part of completed session snapshot if history is needed.

Relationships:

- Belongs to `PracticePlan`.
- Becomes current active item in `PracticeSession`.

### PracticeSession

Purpose: track an active practice session.

Type: struct for value state inside a feature store.

Important fields:

- `id`
- `plan`
- `startedAt`
- `status`
- `currentItemIndex`
- `completedItemIDs`
- `skippedItemIDs`
- `notes`

Persistence: active session can be transient in the first slice; result persists on completion.

Relationships:

- Created from `PracticePlan`.
- Produces `PracticeSessionResult`.

### PracticeSessionResult

Purpose: store the outcome of a completed session.

Type: struct.

Important fields:

- `id`
- `sessionID`
- `practiceType`
- `startedAt`
- `endedAt`
- `completedDrillCount`
- `skippedDrillCount`
- `qualityRating`
- `carryForwardCue`

Persistence: persisted P1 after the in-memory vertical slice works.

Relationships:

- References or embeds one `CarryForwardCue`.
- Feeds Home summary and history.

### CarryForwardCue

Purpose: preserve one concise takeaway after practice.

Type: struct.

Important fields:

- `id`
- `text`
- `sourceSessionID`
- `createdAt`
- `practiceType`

Persistence: persisted P1.

Relationships:

- Created during BucketStrike completion.
- Displayed on Home.

## Tempo Models

### TempoSettings

Purpose: represent user-selected tempo preferences.

Type: struct.

Important fields:

- `bpm`
- `ratio`
- `audioMode`
- `hapticsEnabled`

Persistence: persisted P1.

Relationships:

- Read by Tempo UI.
- Read by `TempoTimingEngine`.
- Read by audio/haptic cue services.

### TempoSession

Purpose: represent the current run of the tempo trainer.

Type: struct.

Important fields:

- `id`
- `settings`
- `state`
- `startedAt`
- `elapsedTime`
- `currentPhase`

Persistence: transient.

Relationships:

- Owned by Tempo feature state.
- Uses `TempoSettings`.

## Colt's Caddy Models

### CaddyMessage

Purpose: represent one message in the conversation.

Type: struct.

Important fields:

- `id`
- `role` (`user`, `assistant`, `system` if needed)
- `text`
- `createdAt`
- `contextSnapshot`

Persistence: transient for v1 shell; persisted P2 only after behavior stabilizes.

Relationships:

- Belongs to `CaddyConversation`.
- May include a `ShotContext` snapshot for auditability.

### CaddyConversation

Purpose: group messages and active context.

Type: struct.

Important fields:

- `id`
- `messages`
- `activeShotContext`
- `createdAt`
- `updatedAt`

Persistence: transient first; optional P2 persistence.

Relationships:

- Contains `CaddyMessage` values.
- Owns or references active `ShotContext`.

### ShotContext

Purpose: capture explicit course/shot information for recommendations.

Type: struct.

Important fields:

- `holeNumber`
- `par`
- `distanceToTargetYards`
- `windDescription`
- `elevationFeet`
- `lie`
- `hazards`
- `targetIntent`

Persistence: transient first; recent context may persist later.

Relationships:

- Read by deterministic and AI Caddy response services.
- Displayed by context card.

## Models To Avoid For Now

Do not add these until a real use case appears:

- User account.
- Cloud profile.
- Course database.
- GPS shot tracker.
- Analytics event schema.
- Generic repository model.
- Generic AI conversation framework.

## Persistence Recommendation

Order of implementation:

1. In-memory model structs and deterministic data.
2. BucketStrike feature store.
3. Persist `PracticeSessionResult` and `CarryForwardCue`.
4. Persist `TempoSettings`.
5. Persist Caddy history only if the conversation behavior is stable.

Use local-first storage and keep persistence behind feature-specific repositories when the data becomes durable.
