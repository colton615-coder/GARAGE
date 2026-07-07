# Garage Screen Specs

## Home

### Purpose

Give the golfer a clear command center for today's practice.

### Primary User Action

Open the most relevant next practice action.

### Sections

- Header: Garage title and short supporting line.
- Today's Focus: one featured practice plan card.
- Training Tools: rows for BucketStrike, Tempo, and Colt's Caddy.
- Carry Forward: one recent note or reminder.

### Placeholder Content

- Today's Focus: Tempo Control.
- Tool rows: BucketStrike, Tempo, Colt's Caddy.
- Carry Forward: "Work on transitioning to your lead side earlier in the downswing."

### UI Components Needed

- `GarageSectionHeader`
- `GarageCard`
- `GarageToolRow`
- `GaragePrimaryButton`

### Out Of Scope For Now

- Real practice history.
- Saved notes.
- Personalization engine.
- Remote data.

## BucketStrike

### Purpose

Create focused golf practice sessions for the range, net, short game, and putting.

### Primary User Action

Start building a practice session.

### Sections

- Header: BucketStrike purpose.
- Practice Type: range, net, short game, putting.
- Session Focus: contact, start line, distance control, scoring.
- Placeholder Plan: static sample routine.

### Placeholder Content

- "30-minute range session"
- "Start line ladder"
- "10 balls per station"

### UI Components Needed

- Segmented-style mode selector.
- Glass rows for practice focus.
- Primary start button.

### Out Of Scope For Now

- Real drill generation.
- Scoring.
- History.
- Persistence.

## Tempo

### Purpose

Train rhythm and timing through separate Guided Swing and Metronome tools.

### Primary User Action

Start a tempo session.

### Sections

- Header: Tempo title and short purpose.
- Visual Timing Hero: BPM, ratio, and phase markers.
- Controls: BPM, ratio, audio mode, haptics.
- Primary Action: Start Session.

### Placeholder Content

- BPM: 120 in mockup direction, but live LIFE-IN-SYNC Tempo Builder may use lower golf-specific ranges.
- Ratio: 3.0:1.
- Audio: Metronome placeholder.
- Haptics: On placeholder.

### UI Components Needed

- Timing dial or arc placeholder.
- Settings rows.
- Primary action button.

### Out Of Scope For Now

- Real audio engine.
- Real haptics.
- Guided Swing timing scheduler.
- Metronome engine.
- Persistence.

## Colt's Caddy

### Purpose

Provide advisory shot and course help in a controlled, local prototype surface.

### Primary User Action

Ask for shot guidance.

### Sections

- Header: assistant identity and status.
- Hole Context: hole, par, yardage, wind, elevation.
- Conversation: static sample exchange.
- Prompt Chips: Club Help, Lie, Wind, Recovery.
- Input Bar: disabled or local-only placeholder.

### Placeholder Content

- Hole 7, Par 4, 165 yards.
- Assistant recommends a 7-iron with uphill/wind context.

### UI Components Needed

- Hole context panel.
- Message bubbles.
- Prompt chip row.
- Input bar placeholder.

### Out Of Scope For Now

- Real AI API calls.
- Course database.
- Live location.
- Persistent chat history.
- Automated decision-making.
