# Garage Navigation Architecture

## Bottom Tab Structure

Garage uses a four-tab root:

1. Home
2. BucketStrike
3. Tempo
4. Colt's Caddy

The root tab shell owns tab selection only. Each module owns its own internal navigation.

## Screen Ownership Rules

| Area | Owner |
| --- | --- |
| Tab selection | Garage root shell |
| Today's focus and tool entry points | Home |
| Practice-session setup and drill flow | BucketStrike |
| Tempo, Guided Swing, Metronome controls | Tempo |
| Shot help and advisory conversation | Colt's Caddy |

Do not move module logic into Home just because Home links to it. Home should launch or summarize, not own the feature.

## Navigation Principles

- Keep the first shell simple: `TabView` plus four root screens.
- Add `NavigationStack` per tab when a tab gains drill detail, tempo settings, or chat/history screens.
- Use enum-based routes when navigation grows beyond one level.
- Avoid global routers until the app earns that complexity.
- Use sheets for temporary setup or settings flows, not primary module navigation.

## Module Boundaries

Garage is one module inside LIFE-IN-SYNC, but it contains separate feature lanes:

- BucketStrike owns practice planning.
- Tempo owns rhythm, BPM, ratio, Guided Swing, and Metronome.
- Colt's Caddy owns advisory shot help.
- Home owns summary and launch surfaces.

Guided Swing and Metronome must remain separate tools. Guided Swing is for golf swing sequencing. Metronome is for steady beat training.

## Home Relationship To Tools

Home may show:

- Today's focus.
- Shortcuts into BucketStrike, Tempo, and Colt's Caddy.
- Carry-forward notes.

Home should not duplicate the full interaction model of any tool.

## Rules To Prevent Feature Soup

- One primary action per screen.
- No mixed dashboards with unrelated controls.
- No AI assistant actions that mutate data without a visible user command.
- No hidden persistence in prototype placeholders.
- No backend, account, analytics, or sync work in the starter shell.
- Add depth only after the user flow is clear.
