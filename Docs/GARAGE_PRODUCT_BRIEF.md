# Garage Product Brief

## What Garage Is

Garage is a native SwiftUI golf improvement module focused on deliberate practice, tempo training, and on-course decision support. It should feel like a premium Apple-native practice system: calm, serious, tactile, and useful.

Garage is not a social product, SaaS dashboard, gambling tool, club-commerce app, or generic habit tracker. For v1, it should stay local-first and avoid accounts, backend services, subscriptions, analytics SDKs, collaboration, cloud sync, and third-party dependencies unless explicitly approved.

## Core Promise

Help a golfer practice with more intent, build trustworthy swing rhythm, and make clearer shot decisions without turning the experience into noisy golf cosplay.

## Target User

- A serious recreational golfer who wants structured practice without a coach in the room.
- A player who values clear routines, fast setup, and a calm training surface.
- A golfer who wants practical shot help and tempo feedback, not entertainment UI.

## Four-Tab Structure

### Home

The Garage command center. It surfaces today's focus, quick access to the main tools, and carry-forward notes from recent practice.

### BucketStrike

A purposeful practice-session generator for range, net, short-game, and putting work. The goal is focused execution, not random drills.

### Tempo

A swing tempo and rhythm trainer using BPM, swing ratio, visual timing, and eventually audio/haptics. Guided Swing and Metronome must remain separate tools.

### Colt's Caddy

An advisory golf assistant for shot help, course strategy, hole planning, lie/wind/recovery advice, and quick round guidance. It must not silently create, mutate, delete, sync, or infer user data without visible user action.

## V1 Should Include

- A native four-tab shell.
- Placeholder-first screens that establish visual hierarchy and navigation ownership.
- Local placeholder content for Home, BucketStrike, Tempo, and Colt's Caddy.
- Shared design tokens and simple SwiftUI primitives.
- Clear out-of-scope labels in docs, not in the app UI.
- Accessible contrast, Dynamic Type-friendly layout, and SF Symbol-based iconography.

## V1 Should Not Include

- Real AI chat networking.
- Real drill generation logic.
- Real tempo/audio/haptic engine.
- Persistence or databases.
- User accounts or login.
- Cloud sync or backend services.
- Analytics, monetization, subscriptions, or paywalls.
- Broad architecture abstractions before the product earns them.
