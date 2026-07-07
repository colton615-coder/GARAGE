---
name: simulator-proof
description: Verify a Garage iOS UI or interaction in Simulator by building, launching, navigating to the exact changed state, interacting with controls, inspecting the rendered UI, checking logs when relevant, and reporting proof. Use before declaring visible or interactive SwiftUI work complete. Do not use for documentation-only tasks.
---

# Simulator Proof

Read `references/verification-matrix.md`.

## Objective

Replace source-code confidence with rendered and interactive evidence.

## Workflow

### 1. Confirm simulator availability

Determine:
- project or workspace
- scheme
- available or booted simulator
- runtime compatibility

If the environment is blocked, report the exact blocker and stop making visual claims.

### 2. Build and launch

Build the actual app target.

After a successful build:
- launch the app
- verify the expected app is running
- inspect the current UI before interaction

A successful compile is not simulator proof.

### 3. Navigate to the changed state

Reproduce the shortest realistic user path.

Examples:
- Home -> BucketStrike -> plan -> active practice
- Home -> Tempo -> start rhythm trainer
- Home -> Colt's Caddy -> focus input -> send test interaction when implemented

Do not validate only an easy neighboring state.

### 4. Exercise the changed interaction

Test the control or state that changed.

Examples:
- scroll instructional content
- expand or collapse detail
- start / pause / resume
- increment rep
- skip drill
- end session
- switch profile
- type and send
- dismiss sheet
- rotate only when relevant to the task

### 5. Inspect visual result

Check:
- clipping
- overlap
- tab-bar collision
- safe-area collision
- unreadable text
- hidden instruction content
- broken disabled states
- wrong hierarchy
- layout instability after state change

Capture a screenshot or equivalent visual evidence when tooling allows.

### 6. Check logs when behavior matters

Inspect logs for:
- crashes
- assertion failures
- repeated runtime warnings
- state or persistence errors
- audio/haptic setup issues when relevant

Do not dump irrelevant logs. Report only meaningful findings.

### 7. Report proof

State:
- simulator model/runtime
- exact path taken
- interactions performed
- visible result
- logs inspected or not needed
- remaining unverified states

## Rule

Never use phrases equivalent to "visually verified" unless the rendered app state was actually inspected.
