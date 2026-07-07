---
name: bucketstrike-flow-guardian
description: Inspect, change, or verify BucketStrike plans, drill teaching, active-practice UI, tracker modes, timers, reps, session progress, plan editing, completion, reflection, or drill routing. Use for any BucketStrike flow or behavior task. Do not use for unrelated Garage tabs.
---

# BucketStrike Flow Guardian

Read `references/bucketstrike-contract.md` before editing.

## Objective

Protect the complete BucketStrike training journey while allowing narrow, testable improvements.

## Workflow

### 1. Map the affected seam

Before editing, identify:
- entry point into the flow
- plan model and plan identity
- drill model and canonical drill identity
- teaching-content source or adapter
- active-practice state owner
- tracker mode
- timer / rep / open-practice behavior
- next / skip / end behavior
- completion or reflection destination

Do not edit until the real ownership chain is understood.

### 2. Classify the task

Choose the narrowest category:
- visual composition
- teaching content
- plan generation or selection
- drill routing / identity
- tracker behavior
- timer behavior
- rep behavior
- session progress
- plan editing
- completion / reflection

Avoid touching categories outside the task without a demonstrated dependency.

### 3. Protect identity

Do not casually change:
- canonical drill IDs
- aliases
- plan IDs
- tracker-mode mapping
- navigation destinations
- saved-history compatibility

If an ID or alias problem exists, trace the mapping from source data to the rendered active drill before patching.

### 4. Protect the practice experience

The active screen should prioritize:
1. drill identity
2. goal
3. setup
4. cue
5. execution tracker
6. essential actions

Keep instructional copy player-facing and actionable.

For compact active-practice teaching:
- Setup: target 3 concise bullets maximum unless the drill genuinely cannot be executed safely or correctly without more
- Cue: target 2 concise bullets maximum
- do not surface diagnostic essays, generic fault lists, or coaching filler in the execution cockpit
- do not hide essential setup information merely to reduce height

### 5. Respect tracker modes

Timed, manual-rep, and open-practice modes are not interchangeable visual skins.

For each changed mode, verify:
- start / pause / resume if applicable
- reset behavior
- rep increment / correct / miss behavior if applicable
- skip / next behavior
- end-session behavior
- state persistence during navigation when intended

Do not force all tracker modes into one generic interaction shell when their jobs differ.

### 6. Verify end-to-end

Use the smallest representative route:
- launch BucketStrike
- open the first available plan
- start the session
- enter active practice
- exercise the changed tracker or teaching state
- advance at least one drill when relevant
- end or complete when the task touches completion

Use `simulator-proof` for user-visible changes.

## Output

### BucketStrike seam inspected
List the ownership chain.

### Change
Describe the narrow behavior or UI change.

### Protected behavior
State what was intentionally preserved.

### Verification
Report exact build and flow proof.

### Remaining risk
Name unresolved data, routing, content, or state risk.
