---
name: garage-ui-guardian
description: Audit, redesign, or implement Garage SwiftUI screens and components while preserving the approved premium dark Garage visual language. Use for UI, UX, layout, styling, hierarchy, glass, spacing, typography, controls, screen composition, screenshot-driven redesigns, or visual polish. Do not use for behavior-only fixes with no visual impact.
---

# Garage UI Guardian

Use this workflow for visual changes in Garage.

## Objective

Protect visual continuity while improving hierarchy, usability, and instructional clarity.

Read `references/visual-contract.md` before editing.

## Workflow

### 1. Diagnose before prescribing

Inspect:
- the target screen
- its shared theme and design-system dependencies
- nearby approved screens
- repeated components already available
- screenshots, recordings, Figma references, or user-approved visual targets when provided

Name the primary visual disease before editing. Examples:
- hierarchy collapse
- card stack
- dead-space drift
- control competition
- typography imbalance
- instructional compression
- visual drift
- decorative noise

Do not start by inventing a new component kit.

### 2. Protect the visual contract

Preserve:
- dark system foundation
- deep emerald / black-green identity
- restrained gold accents
- selective glass
- editorial spacing
- strong primary action hierarchy
- readable training instructions

Do not:
- stack containers without a functional reason
- make every region a card
- apply glow, gradients, blur, or glass everywhere
- make secondary controls compete with the main action
- replace the Garage identity with a generic template aesthetic
- hide instruction content merely to create empty space

### 3. Reuse before creating

Search for:
- Garage theme tokens
- shared buttons
- pills/chips
- section headers
- dividers
- panels
- typography styles
- navigation patterns

Reuse existing primitives when they fit. Create a new shared primitive only when repetition or a stable design role justifies it.

### 4. Keep behavior stable

Unless behavior change is explicitly requested:
- preserve navigation
- preserve IDs and model identity
- preserve actions and state transitions
- preserve persistence behavior
- preserve timer, tracker, and session logic

A visual task is not permission for an architecture rewrite.

### 5. Implement in narrow slices

Prefer:
- hierarchy and spacing first
- component composition second
- decorative polish last

Build after structural changes before adding another layer of visual work.

### 6. Verify the rendered result

For meaningful visible changes:
- build the app
- launch Simulator when available
- navigate to the exact changed state
- capture or inspect the rendered screen
- test the changed interaction
- compare against the target direction

Use `simulator-proof` when available.

## Output

Report:
- Visual disease
- Files changed
- What changed visually
- What behavior stayed unchanged
- Verification
- Remaining visual risk

Do not call a redesign successful solely from source code review.
