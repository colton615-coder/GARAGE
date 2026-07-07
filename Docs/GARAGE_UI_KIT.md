# Garage UI Kit

## Visual Direction

Garage should read as a dark Apple-native system app with restrained glass surfaces, focused hierarchy, and practical golf context. The attached mockups are direction references, not exact screens to clone.

The feel should be premium sport-tech: quiet, controlled, tactile, and useful.

Avoid cheesy golf luxury, gold-heavy styling, serif typography, fake leather, country-club cosplay, cluttered stat walls, and generic gradient-heavy AI UI.

## Color Tokens

Use semantic SwiftUI colors first, then lightweight Garage tokens where needed.

| Token | Purpose | Suggested Value |
| --- | --- | --- |
| `backgroundPrimary` | Root dark app background | near-black system background |
| `backgroundElevated` | Glass panel fill | dark gray with opacity/material |
| `borderSubtle` | Panel and divider stroke | white at low opacity |
| `textPrimary` | Main titles and values | system white |
| `textSecondary` | Supporting labels | system gray |
| `accentBlue` | Primary actions, selected tab, key values | Apple blue |
| `accentGreen` | tempo phase, readiness, success | restrained green |
| `warning` | only when needed | system orange |

Do not let the palette collapse into all-blue or all-green. Blue should own primary action; green should signal tempo/phase or readiness.

## Typography Rules

- Use system font only.
- Large screen titles should be bold and direct.
- Section headers should be uppercase, spaced, and secondary.
- Metric values can be large, but only when they are the main task.
- Avoid serif fonts, decorative type, negative tracking, and viewport-scaled type.

## Spacing Rules

- Root horizontal padding: 20-24 pt.
- Section spacing: 28-36 pt.
- Row internal padding: 16-20 pt.
- Compact dividers inside grouped panels.
- Avoid card-inside-card clutter.

## Card and Glass Panel Style

- Use subtle material or translucent dark fills.
- Use one thin border.
- Keep shadows restrained or absent.
- Use radius consistently; prefer native-feeling rounded rectangles without exaggerated pill shapes.
- Cards should frame real repeated items or controls, not every page section.

## Button Styles

- Primary action: full-width, blue, clear command label, SF Symbol when useful.
- Secondary action: glass row or subtle bordered control.
- Icon-only controls: use SF Symbols with accessibility labels.
- Avoid decorative buttons that do not map to a clear action.

## Bottom Tab Bar Behavior

- Four tabs only: Home, BucketStrike, Tempo, Colt's Caddy.
- Each tab owns its own navigation stack when the project grows.
- Tab icons should be recognizable SF Symbols, not custom novelty art.
- The selected tab should use blue. Inactive tabs should be subdued.

## Icon Style

- Use SF Symbols for v1.
- Prefer simple line icons with consistent weight.
- Golf context should be restrained: target, bucket, waveform/timing, caddy/help.
- Avoid icon noise and mascot-heavy treatment.

## Accessibility and Contrast

- Maintain contrast on translucent panels.
- Do not rely on color alone for state.
- Keep touch targets at least 44 pt.
- Let text wrap naturally for Dynamic Type.
- Avoid placing important text over visually busy images unless contrast is guaranteed.

## Patterns To Avoid

- Heavy card stacks.
- Generic blue-purple glow.
- Gold luxury UI.
- Country-club visual clichés.
- Dense stat dashboards.
- Fake chat intelligence without clear scope.
- Decorative golf imagery that does not support a user decision.
