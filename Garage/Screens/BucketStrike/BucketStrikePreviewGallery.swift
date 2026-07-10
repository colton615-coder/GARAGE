import SwiftUI

#Preview("Gallery — Focus Card") {
    BucketPreviewCanvas {
        HStack(spacing: 10) {
            BucketFocusCard(
                focus: BucketSessionFocus.focuses(for: .range)[0],
                isSelected: true
            ) {}

            BucketFocusCard(
                focus: BucketSessionFocus.focuses(for: .range)[1],
                isSelected: false
            ) {}
        }
    }
    .preferredColorScheme(.dark)
}

#Preview("Gallery — Drill Row") {
    BucketPreviewCanvas {
        BucketDrillRow(drill: BucketPreviewContent.manualDrill)
    }
    .preferredColorScheme(.dark)
}

#Preview("Gallery — Plan Summary") {
    BucketPreviewCanvas {
        BucketSummaryStrip(plan: BucketPreviewContent.plan)
    }
    .preferredColorScheme(.dark)
}

#Preview("Gallery — Setup Card") {
    BucketPreviewCanvas {
        BucketSetupTeachingView(
            drill: BucketPreviewContent.manualDrill,
            drillNumber: 1,
            drillCount: BucketPreviewContent.plan.drills.count,
            onStart: {},
            onShowIntel: {}
        )
    }
    .preferredColorScheme(.dark)
}

#Preview("Gallery — Active Manual Tracker") {
    BucketPreviewCanvas {
        BucketDrillExecutionTracker(
            drill: BucketPreviewContent.manualDrill,
            state: BucketPreviewContent.manualState,
            onStartTimer: {},
            onPauseTimer: {},
            onResetTimer: {}
        )
    }
    .preferredColorScheme(.dark)
}

#Preview("Gallery — Active Timed Tracker") {
    BucketPreviewCanvas {
        BucketDrillExecutionTracker(
            drill: BucketPreviewContent.timedDrill,
            state: BucketPreviewContent.timedState,
            onStartTimer: {},
            onPauseTimer: {},
            onResetTimer: {}
        )
    }
    .preferredColorScheme(.dark)
}

#Preview("Gallery — Drill Complete Card") {
    BucketPreviewCanvas {
        BucketDrillCompleteView(
            drill: BucketPreviewContent.manualDrill,
            state: BucketPreviewContent.manualState,
            isFinalDrill: false,
            onContinue: {},
            onReview: {}
        )
    }
    .preferredColorScheme(.dark)
}

#Preview("Gallery — Session Complete Card") {
    BucketSessionCompleteView(
        plan: BucketPreviewContent.plan,
        onReturn: {}
    )
    .background(GarageTheme.background)
    .preferredColorScheme(.dark)
}

#Preview("Gallery — Action Bar") {
    BucketPreviewCanvas {
        BucketActiveActionBar(
            canGoPrevious: true,
            isFinalDrill: false,
            onPrevious: {},
            onAdvance: {}
        )
    }
    .preferredColorScheme(.dark)
}

#Preview("Gallery — Final Action Bar") {
    BucketPreviewCanvas {
        BucketActiveActionBar(
            canGoPrevious: true,
            isFinalDrill: true,
            onPrevious: {},
            onAdvance: {}
        )
    }
    .preferredColorScheme(.dark)
}

#Preview("Proposal — Preflight Strip") {
    BucketPreviewCanvas {
        SetupProposalPreflightStrip(drill: BucketPreviewContent.manualDrill) {}
    }
    .preferredColorScheme(.dark)
}

#Preview("Proposal — Coach Card") {
    BucketPreviewCanvas {
        SetupProposalCoachCard(drill: BucketPreviewContent.manualDrill) {}
    }
    .preferredColorScheme(.dark)
}

#Preview("Proposal — Cockpit") {
    BucketPreviewCanvas {
        SetupProposalCockpit(drill: BucketPreviewContent.manualDrill) {}
    }
    .preferredColorScheme(.dark)
}

#Preview("Proposal — Minimal Range") {
    BucketPreviewCanvas {
        SetupProposalMinimalRange(drill: BucketPreviewContent.manualDrill) {}
    }
    .preferredColorScheme(.dark)
}

#Preview("Proposal — Scoreboard Ring") {
    BucketPreviewCanvas {
        ActiveProposalScoreboardRing(
            drill: BucketPreviewContent.manualDrill,
            state: BucketPreviewContent.manualState
        )
    }
    .preferredColorScheme(.dark)
}

#Preview("Proposal — Rep Ladder") {
    BucketPreviewCanvas {
        ActiveProposalRepLadder(
            drill: BucketPreviewContent.manualDrill,
            state: BucketPreviewContent.manualState
        )
    }
    .preferredColorScheme(.dark)
}

#Preview("Proposal — Focus First") {
    BucketPreviewCanvas {
        ActiveProposalFocusFirst(
            drill: BucketPreviewContent.manualDrill,
            state: BucketPreviewContent.manualState
        )
    }
    .preferredColorScheme(.dark)
}

#Preview("Proposal — Console") {
    BucketPreviewCanvas {
        ActiveProposalConsole(
            drill: BucketPreviewContent.manualDrill,
            state: BucketPreviewContent.manualState
        )
    }
    .preferredColorScheme(.dark)
}

#Preview("Proposal — Thumb Reach") {
    BucketPreviewCanvas {
        ActiveProposalThumbReach(
            drill: BucketPreviewContent.manualDrill,
            state: BucketPreviewContent.manualState
        )
    }
    .preferredColorScheme(.dark)
}

struct SetupProposalPreflightStrip: View {
    let drill: BucketPlanDrill
    let onStart: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Preflight")
                        .font(.caption.weight(.bold))
                        .tracking(1.4)
                        .textCase(.uppercase)
                        .foregroundStyle(GarageTheme.accentGreen)

                    Text(drill.setupTitle)
                        .font(.title2.weight(.bold))
                        .foregroundStyle(.white)
                        .lineLimit(2)
                }

                Spacer()

                Text(drill.goalText)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(GarageTheme.textSecondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: 120, alignment: .trailing)
            }

            VStack(spacing: 10) {
                ForEach(drill.setupStepTexts.prefix(3), id: \.self) { step in
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "checkmark")
                            .font(.caption.weight(.heavy))
                            .foregroundStyle(GarageTheme.accentGreen)
                            .frame(width: 18, height: 18)

                        Text(step)
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.white.opacity(0.82))
                            .fixedSize(horizontal: false, vertical: true)

                        Spacer(minLength: 0)
                    }
                }
            }

            Button(action: onStart) {
                Label(drill.startButtonTitle, systemImage: "play.fill")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.black.opacity(0.86))
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(GarageTheme.accentGreen)
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(GarageTheme.panelFill)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(GarageTheme.border, lineWidth: 1)
                )
        )
    }
}

struct SetupProposalCoachCard: View {
    let drill: BucketPlanDrill
    let onStart: () -> Void

    private var setupLine: String {
        drill.setupStepTexts.first ?? drill.setupInstructionText
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Setup")
                    .font(.caption.weight(.semibold))
                    .tracking(1.6)
                    .textCase(.uppercase)
                    .foregroundStyle(GarageTheme.accentGreen)

                Text(drill.setupTitle)
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }

            VStack(alignment: .leading, spacing: 16) {
                SetupProposalEditorialLine(title: "Do", text: setupLine)
                SetupProposalEditorialLine(title: "Cue", text: drill.primaryCueText)
                SetupProposalEditorialLine(title: "Track", text: drill.goalText)
            }

            Button(action: onStart) {
                HStack {
                    Text("Begin")
                        .font(.headline.weight(.semibold))

                    Spacer()

                    Image(systemName: "arrow.right")
                        .font(.headline.weight(.bold))
                }
                .foregroundStyle(.white)
                .padding(.vertical, 14)
                .padding(.horizontal, 16)
                .background(GarageTheme.backgroundRaised)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(GarageTheme.accentGreen.opacity(0.45), lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
        }
        .padding(22)
        .background(
            RoundedRectangle(cornerRadius: GarageTheme.cardRadius, style: .continuous)
                .fill(GarageTheme.panelFill)
                .overlay(
                    RoundedRectangle(cornerRadius: GarageTheme.cardRadius, style: .continuous)
                        .stroke(GarageTheme.border, lineWidth: 1)
                )
        )
    }
}

struct SetupProposalCockpit: View {
    let drill: BucketPlanDrill
    let onStart: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 12) {
                GarageIcon(symbolName: drill.symbolName, color: GarageTheme.accentGreen)

                VStack(alignment: .leading, spacing: 4) {
                    Text(drill.displayTitle)
                        .font(.headline.weight(.heavy))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.82)

                    Text(drill.setupTitle)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(GarageTheme.textSecondary)
                        .lineLimit(2)
                }

                Spacer(minLength: 0)
            }

            Divider()
                .overlay(GarageTheme.divider)

            HStack(alignment: .top, spacing: 10) {
                SetupProposalCockpitTile(title: "Setup", text: drill.setupStepTexts.first ?? drill.setupInstructionText)
                SetupProposalCockpitTile(title: "Cue", text: drill.primaryCueText)
            }

            HStack(spacing: 10) {
                SetupProposalMetricPill(title: "Track", value: drill.goalText)
                SetupProposalMetricPill(title: "Mode", value: drill.startButtonTitle)
            }

            Button(action: onStart) {
                Label("Start Block", systemImage: "bolt.fill")
                    .font(.headline.weight(.heavy))
                    .foregroundStyle(.black.opacity(0.86))
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(GarageTheme.accentGreen)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .buttonStyle(.plain)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(GarageTheme.backgroundRaised)
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(GarageTheme.border, lineWidth: 1)
                )
        )
    }
}

struct SetupProposalMinimalRange: View {
    let drill: BucketPlanDrill
    let onStart: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Set the station")
                    .font(.caption.weight(.bold))
                    .tracking(1.5)
                    .textCase(.uppercase)
                    .foregroundStyle(GarageTheme.accentGreen)

                Text(drill.setupTitle)
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }

            VStack(alignment: .leading, spacing: 14) {
                ForEach(drill.setupStepTexts.prefix(2), id: \.self) { step in
                    Text(step)
                        .font(.body.weight(.medium))
                        .foregroundStyle(.white.opacity(0.82))
                        .fixedSize(horizontal: false, vertical: true)

                    Divider()
                        .overlay(GarageTheme.divider)
                }

                Text(drill.primaryCueText)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 36)

            Button(action: onStart) {
                HStack {
                    Label(drill.startButtonTitle, systemImage: "play.fill")
                        .font(.headline.weight(.bold))

                    Spacer()

                    Text(drill.goalText)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.black.opacity(0.58))
                        .lineLimit(1)
                }
                .foregroundStyle(.black.opacity(0.86))
                .padding(.vertical, 16)
                .padding(.horizontal, 18)
                .background(GarageTheme.accentGreen)
                .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 2)
        .frame(minHeight: 520, alignment: .top)
    }
}

struct SetupProposalEditorialLine: View {
    let title: String
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption.weight(.bold))
                .tracking(1.2)
                .textCase(.uppercase)
                .foregroundStyle(GarageTheme.accentGreen)

            Text(text)
                .font(.body.weight(.medium))
                .foregroundStyle(.white.opacity(0.82))
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct SetupProposalCockpitTile: View {
    let title: String
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption2.weight(.bold))
                .tracking(1.1)
                .textCase(.uppercase)
                .foregroundStyle(GarageTheme.accentGreen)

            Text(text)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white.opacity(0.82))
                .lineLimit(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(GarageTheme.panelFill)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(GarageTheme.border, lineWidth: 1)
        )
    }
}

struct SetupProposalMetricPill: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(.caption2.weight(.bold))
                .tracking(1.1)
                .textCase(.uppercase)
                .foregroundStyle(GarageTheme.textSecondary)

            Text(value)
                .font(.caption.weight(.bold))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.72)
        }
        .padding(.vertical, 9)
        .padding(.horizontal, 11)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(GarageTheme.iconFill)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

// MARK: - Active Execution Proposals

// Catalog successActionTitle values embed a leading "+ "; strip it where the
// proposal button already renders its own plus glyph.
private extension BucketPlanDrill {
    var proposalSuccessTitle: String {
        guard successActionTitle.hasPrefix("+") else { return successActionTitle }
        return successActionTitle.dropFirst().trimmingCharacters(in: .whitespaces)
    }
}

/// Proposal 1 — Scoreboard Ring: the count is the whole interface. Tapping the
/// ring logs a rep, so there is no hunting for a button mid-swing.
struct ActiveProposalScoreboardRing: View {
    let drill: BucketPlanDrill
    let state: BucketDrillExecutionState
    var onIncrement: () -> Void = {}
    var onDecrement: () -> Void = {}
    var onReset: () -> Void = {}
    var onComplete: () -> Void = {}

    private var target: Int { drill.executionConfiguration.targetReps ?? 0 }

    private var ringProgress: Double {
        guard target > 0 else { return 0 }
        return min(1, Double(state.succeeded) / Double(target))
    }

    var body: some View {
        VStack(spacing: 18) {
            VStack(spacing: 4) {
                Text(drill.displayTitle)
                    .font(.headline.weight(.heavy))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Text(drill.compactExecutionText)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(GarageTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }

            Button(action: onIncrement) {
                ZStack {
                    Circle()
                        .stroke(.white.opacity(0.08), lineWidth: 10)

                    Circle()
                        .trim(from: 0, to: ringProgress)
                        .stroke(
                            GarageTheme.accentGreen,
                            style: StrokeStyle(lineWidth: 10, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))

                    VStack(spacing: 2) {
                        Text("\(state.succeeded)")
                            .font(.system(size: 76, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .monospacedDigit()

                        Text(target > 0 ? "of \(target)" : "recorded")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(GarageTheme.textSecondary)
                    }
                }
                .frame(width: 230, height: 230)
                .contentShape(Circle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(drill.successActionTitle)

            Label("Tap the ring to log one", systemImage: "hand.tap")
                .font(.caption.weight(.semibold))
                .foregroundStyle(GarageTheme.accentGreen)

            HStack(spacing: 10) {
                ActiveProposalIconButton(symbolName: "minus", label: drill.correctionActionTitle, action: onDecrement)
                ActiveProposalIconButton(symbolName: "arrow.counterclockwise", label: "Reset", action: onReset)

                Button(action: onComplete) {
                    Label("Finish Drill", systemImage: "checkmark.circle")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.white.opacity(0.86))
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(.white.opacity(0.07))
                        .clipShape(Capsule())
                        .overlay {
                            Capsule()
                                .stroke(.white.opacity(0.14), lineWidth: 1)
                        }
                }
                .buttonStyle(.plain)
            }

            Text(drill.primaryCueText)
                .font(.footnote.weight(.medium))
                .foregroundStyle(GarageTheme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(BucketActiveSurface())
    }
}

/// Proposal 2 — Rep Ladder: the target is drawn as physical rungs that fill as
/// swings land, so progress toward the goal is glanceable from address.
struct ActiveProposalRepLadder: View {
    let drill: BucketPlanDrill
    let state: BucketDrillExecutionState
    var onIncrement: () -> Void = {}
    var onDecrement: () -> Void = {}
    var onReset: () -> Void = {}
    var onComplete: () -> Void = {}

    private var target: Int { drill.executionConfiguration.targetReps ?? 0 }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .firstTextBaseline) {
                Text(drill.displayTitle)
                    .font(.title3.weight(.heavy))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Spacer(minLength: 10)

                Text(target > 0 ? "\(state.succeeded)/\(target)" : "\(state.succeeded)")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(GarageTheme.accentGreen)
                    .monospacedDigit()
            }

            if target > 0, target <= 20 {
                HStack(spacing: 5) {
                    ForEach(0..<target, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 3, style: .continuous)
                            .fill(index < state.succeeded ? GarageTheme.accentGreen : Color.white.opacity(0.10))
                            .frame(height: 26)
                    }
                }
            } else {
                ProgressView(value: target > 0 ? min(1, Double(state.succeeded) / Double(target)) : 0)
                    .tint(GarageTheme.accentGreen)
            }

            Text(drill.visualProfile?.trackerLabel ?? "Reps recorded")
                .font(.caption.weight(.semibold))
                .tracking(1.0)
                .textCase(.uppercase)
                .foregroundStyle(GarageTheme.textSecondary)

            Button(action: onIncrement) {
                Label(drill.proposalSuccessTitle, systemImage: "plus")
                    .font(.title3.weight(.heavy))
                    .foregroundStyle(.black.opacity(0.86))
                    .frame(maxWidth: .infinity)
                    .frame(height: 62)
                    .background(GarageTheme.accentGreen)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .buttonStyle(.plain)

            HStack(spacing: 10) {
                ActiveProposalIconButton(symbolName: "minus", label: drill.correctionActionTitle, action: onDecrement)
                ActiveProposalIconButton(symbolName: "arrow.counterclockwise", label: "Reset", action: onReset)
                ActiveProposalIconButton(symbolName: "checkmark", label: "Finish Drill", action: onComplete)
            }

            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "target")
                    .font(.footnote.weight(.bold))
                    .foregroundStyle(GarageTheme.accentGreen)
                    .accessibilityHidden(true)

                Text(drill.primaryCueText)
                    .font(.footnote.weight(.medium))
                    .foregroundStyle(.white.opacity(0.78))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.white.opacity(0.035))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .padding(18)
        .background(BucketActiveSurface())
    }
}

/// Proposal 3 — Focus First: the swing thought is the hero and the tracker is
/// demoted to a compact stepper strip, for players who count less and feel more.
struct ActiveProposalFocusFirst: View {
    let drill: BucketPlanDrill
    let state: BucketDrillExecutionState
    var onIncrement: () -> Void = {}
    var onDecrement: () -> Void = {}
    var onComplete: () -> Void = {}
    var onShowIntel: () -> Void = {}

    private var target: Int { drill.executionConfiguration.targetReps ?? 0 }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Swing Thought")
                    .font(.caption.weight(.bold))
                    .tracking(1.5)
                    .textCase(.uppercase)
                    .foregroundStyle(GarageTheme.accentGreen)

                Text(drill.primaryCueText)
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)

                Text(drill.compactExecutionText)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(GarageTheme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Divider()
                .overlay(GarageTheme.divider)

            HStack(spacing: 14) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(state.succeeded)")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .monospacedDigit()

                    Text(target > 0 ? "of \(target)" : "recorded")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(GarageTheme.textSecondary)
                }

                Spacer(minLength: 10)

                Button(action: onDecrement) {
                    Image(systemName: "minus")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.white.opacity(0.8))
                        .frame(width: 56, height: 56)
                        .background(.white.opacity(0.06), in: Circle())
                        .overlay {
                            Circle()
                                .stroke(GarageTheme.border, lineWidth: 1)
                        }
                }
                .buttonStyle(.plain)
                .accessibilityLabel(drill.correctionActionTitle)

                Button(action: onIncrement) {
                    Image(systemName: "plus")
                        .font(.title2.weight(.heavy))
                        .foregroundStyle(.black.opacity(0.86))
                        .frame(width: 72, height: 72)
                        .background(GarageTheme.accentGreen, in: Circle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(drill.successActionTitle)
            }

            if target > 0 {
                ProgressView(value: min(1, Double(state.succeeded) / Double(target)))
                    .tint(GarageTheme.accentGreen)
            }

            HStack(spacing: 10) {
                BucketQuietCapsuleButton(title: "Intel", symbolName: "info.circle", action: onShowIntel)
                BucketQuietCapsuleButton(title: "Finish Drill", symbolName: "checkmark.circle", action: onComplete)
            }
        }
        .padding(20)
        .background(BucketActiveSurface())
    }
}

/// Proposal 4 — Console: an instrument-cluster read of the drill with
/// recorded / target / remaining tiles above a keypad-style control block.
struct ActiveProposalConsole: View {
    let drill: BucketPlanDrill
    let state: BucketDrillExecutionState
    var onIncrement: () -> Void = {}
    var onDecrement: () -> Void = {}
    var onReset: () -> Void = {}
    var onComplete: () -> Void = {}

    private var target: Int { drill.executionConfiguration.targetReps ?? 0 }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                Circle()
                    .fill(GarageTheme.accentGreen)
                    .frame(width: 7, height: 7)

                Text(drill.displayTitle.uppercased())
                    .font(.system(size: 15, weight: .heavy, design: .monospaced))
                    .tracking(1.0)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)

                Spacer(minLength: 8)

                Text("LIVE")
                    .font(.system(size: 10, weight: .heavy, design: .monospaced))
                    .tracking(1.4)
                    .foregroundStyle(GarageTheme.accentGreen)
            }

            HStack(spacing: 10) {
                ActiveProposalConsoleTile(title: "Recorded", value: "\(state.succeeded)", accent: .white)
                ActiveProposalConsoleTile(title: "Target", value: target > 0 ? "\(target)" : "—", accent: GarageTheme.textSecondary)
                ActiveProposalConsoleTile(
                    title: "Left",
                    value: target > 0 ? "\(max(0, target - state.succeeded))" : "—",
                    accent: GarageTheme.accentGreen
                )
            }

            Button(action: onIncrement) {
                Label(drill.proposalSuccessTitle, systemImage: "plus")
                    .font(.system(size: 17, weight: .heavy, design: .monospaced))
                    .foregroundStyle(.black.opacity(0.86))
                    .frame(maxWidth: .infinity)
                    .frame(height: 58)
                    .background(GarageTheme.accentGreen)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .buttonStyle(.plain)

            HStack(spacing: 10) {
                ActiveProposalIconButton(symbolName: "minus", label: drill.correctionActionTitle, action: onDecrement)
                ActiveProposalIconButton(symbolName: "arrow.counterclockwise", label: "Reset", action: onReset)
            }

            Divider()
                .overlay(GarageTheme.divider)

            HStack(alignment: .top, spacing: 10) {
                Text("CUE")
                    .font(.system(size: 10, weight: .heavy, design: .monospaced))
                    .tracking(1.2)
                    .foregroundStyle(GarageTheme.accentGreen)
                    .padding(.top, 2)

                Text(drill.primaryCueText)
                    .font(.footnote.weight(.medium))
                    .foregroundStyle(.white.opacity(0.78))
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: 0)
            }

            BucketQuietCapsuleButton(title: "Finish Drill", symbolName: "checkmark.circle", action: onComplete)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(GarageTheme.backgroundRaised)
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(GarageTheme.border, lineWidth: 1)
                )
        )
    }
}

/// Proposal 5 — Thumb Reach: reference info stays up top while every control
/// drops into the bottom third, sized for one-handed use with a glove on.
struct ActiveProposalThumbReach: View {
    let drill: BucketPlanDrill
    let state: BucketDrillExecutionState
    var onIncrement: () -> Void = {}
    var onDecrement: () -> Void = {}
    var onReset: () -> Void = {}
    var onComplete: () -> Void = {}
    var onShowIntel: () -> Void = {}

    private var target: Int { drill.executionConfiguration.targetReps ?? 0 }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text(drill.displayTitle)
                    .font(.title3.weight(.heavy))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Text(drill.compactExecutionText)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(GarageTheme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            HStack(alignment: .lastTextBaseline, spacing: 8) {
                Text("\(state.succeeded)")
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .monospacedDigit()

                Text(target > 0 ? "of \(target)" : "recorded")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(GarageTheme.textSecondary)

                Spacer(minLength: 0)
            }

            if target > 0 {
                ProgressView(value: min(1, Double(state.succeeded) / Double(target)))
                    .tint(GarageTheme.accentGreen)
            }

            Spacer(minLength: 120)

            HStack(spacing: 10) {
                ActiveProposalIconButton(symbolName: "minus", label: drill.correctionActionTitle, action: onDecrement)
                ActiveProposalIconButton(symbolName: "arrow.counterclockwise", label: "Reset", action: onReset)
                ActiveProposalIconButton(symbolName: "info.circle", label: "Intel", action: onShowIntel)
                ActiveProposalIconButton(symbolName: "checkmark", label: "Finish Drill", action: onComplete)
            }

            Button(action: onIncrement) {
                VStack(spacing: 4) {
                    Image(systemName: "plus")
                        .font(.title.weight(.heavy))

                    Text(drill.proposalSuccessTitle)
                        .font(.headline.weight(.bold))
                }
                .foregroundStyle(.black.opacity(0.86))
                .frame(maxWidth: .infinity)
                .frame(height: 96)
                .background(GarageTheme.accentGreen)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            }
            .buttonStyle(.plain)
        }
        .padding(18)
        .frame(minHeight: 540, alignment: .top)
    }
}

struct ActiveProposalIconButton: View {
    let symbolName: String
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: symbolName)
                .font(.headline.weight(.bold))
                .foregroundStyle(.white.opacity(0.82))
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(.white.opacity(0.06))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(GarageTheme.border, lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
    }
}

struct ActiveProposalConsoleTile: View {
    let title: String
    let value: String
    let accent: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title.uppercased())
                .font(.system(size: 10, weight: .heavy, design: .monospaced))
                .tracking(1.1)
                .foregroundStyle(GarageTheme.textSecondary)

            Text(value)
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundStyle(accent)
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(GarageTheme.panelFill)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(GarageTheme.border, lineWidth: 1)
        )
    }
}
