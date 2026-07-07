# Garage Simulator Verification Matrix

## UI-only change

Minimum:
- build
- launch
- navigate to exact screen
- inspect changed state
- capture visual proof when available

## Interactive control change

Minimum:
- UI-only checks
- activate control
- verify state transition
- verify reverse or alternate state when applicable
- inspect logs if state handling is non-trivial

## BucketStrike tracker change

Minimum:
- open a real plan
- start session
- enter affected drill mode
- exercise primary tracker action
- exercise secondary/reset action when changed
- verify skip/next remains valid
- verify end-session path if touched

## Tempo change

Minimum:
- open Tempo
- start
- inspect active state
- change BPM/ratio when supported
- pause/resume or stop when applicable
- inspect for jank or stuck state
- inspect logs for audio/haptic issues when those systems changed

## Navigation change

Minimum:
- enter destination
- back out
- repeat entry
- switch tabs
- verify navigation state does not leak unexpectedly

## Layout change

Minimum:
- inspect on the target iPhone size used by the project
- test longest expected text
- test active/disabled state when present
- check keyboard presentation when text input exists
- check bottom safe area and tab-bar collision
