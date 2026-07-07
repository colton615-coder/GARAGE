import SwiftUI

struct BucketActiveHeader: View {
    let session: BucketActiveSessionState

    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            HStack(alignment: .firstTextBaseline, spacing: 12) {
                Text(session.currentDrill.displayTitle)
                    .font(.system(size: 27, weight: .bold))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .minimumScaleFactor(0.84)

                Spacer(minLength: 10)

                Text("Drill \(session.currentDrillNumber)/\(session.drillCount)")
                    .font(.caption.weight(.semibold))
                    .tracking(0.8)
                    .foregroundStyle(GarageTheme.textSecondary)
                    .lineLimit(1)
                    .padding(.horizontal, 9)
                    .padding(.vertical, 5)
                    .background(
                        Capsule()
                            .fill(.white.opacity(0.06))
                            .overlay(Capsule().stroke(GarageTheme.border, lineWidth: 1))
                    )
            }

            Text(session.currentDrill.subtitle)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(GarageTheme.textSecondary)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)

            ProgressView(value: session.progressValue)
                .tint(GarageTheme.accentBlue)
        }
    }
}

struct BucketExecutionFlowSpecBlock: View {
    let spec: BucketDrillExecutionFlowSpec

    private var setupStep: BucketDrillExecutionFlowStep? {
        spec.steps.first { $0.id == .setup }
    }

    private var cueStep: BucketDrillExecutionFlowStep? {
        spec.steps.first { $0.id == .cue }
    }

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            BucketInstructionPod(
                title: setupStep?.label ?? "Setup",
                text: setupStep?.activeState ?? spec.measurementBoundary,
                accent: GarageTheme.textSecondary
            )

            BucketInstructionPod(
                title: cueStep?.label ?? "Cue",
                text: cueStep?.activeState ?? spec.title,
                accent: GarageTheme.accentGreen
            )
        }
    }
}

struct BucketInstructionOverlaySheet: View {
    let drill: BucketPlanDrill
    @Binding var isPresented: Bool

    private var content: BucketDrillExecutionContent {
        drill.executionContent
    }

    private var setupText: String {
        if let visualProfile = drill.visualProfile {
            return visualProfile.setupCopy
        }

        if let spec = drill.executionFlowSpec,
           let setup = spec.steps.first(where: { $0.id == .setup }) {
            return setup.activeState
        }

        return content.setup.joined(separator: " ")
    }

    private var cueText: String {
        if let visualProfile = drill.visualProfile {
            return visualProfile.focus
        }

        if let spec = drill.executionFlowSpec,
           let cue = spec.steps.first(where: { $0.id == .cue }) {
            return cue.activeState
        }

        return content.cues.joined(separator: " ")
    }

    private var trackText: String {
        if let visualProfile = drill.visualProfile {
            return "\(visualProfile.executionCommand) Tracker: \(visualProfile.trackerLabel)."
        }

        if let spec = drill.executionFlowSpec,
           let track = spec.steps.first(where: { $0.id == .track }) {
            return track.activeState
        }

        return content.goal
    }

    var body: some View {
        VStack {
            Spacer(minLength: 0)

            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 10) {
                    Label("Drill Intel", systemImage: "info.circle")
                        .font(.system(size: 12, weight: .heavy, design: .monospaced))
                        .tracking(1.0)
                        .foregroundStyle(GarageTheme.accentGreen)

                    Spacer()

                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.white.opacity(0.82))
                            .frame(width: 32, height: 32)
                            .background(.white.opacity(0.06))
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Close drill instructions")
                }

                HStack(alignment: .top, spacing: 10) {
                    BucketInstructionPod(title: "Setup", text: setupText, accent: GarageTheme.textSecondary)
                    BucketInstructionPod(title: "Cue", text: cueText, accent: GarageTheme.accentGreen)
                }

                BucketInstructionPod(title: "Track", text: trackText, accent: GarageTheme.accentBlue)
            }
            .padding(14)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(.white.opacity(0.12), lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.24), radius: 20, x: 0, y: 10)
            .padding(.horizontal, 16)
            .padding(.bottom, 14)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black.opacity(0.28))
    }
}

struct BucketCompactTeachingBlock: View {
    let drill: BucketPlanDrill

    private var content: BucketDrillExecutionContent {
        drill.executionContent
    }

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            BucketInstructionPod(
                title: "Setup",
                text: content.setup.prefix(2).joined(separator: " "),
                accent: GarageTheme.textSecondary
            )

            BucketInstructionPod(
                title: "Cue",
                text: content.cues.prefix(2).joined(separator: " "),
                accent: GarageTheme.accentGreen
            )
        }
    }
}

struct BucketInstructionPod: View {
    let title: String
    let text: String
    let accent: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title.uppercased())
                .font(.system(size: 10, weight: .heavy, design: .monospaced))
                .tracking(0.8)
                .foregroundStyle(accent)
                .lineLimit(1)

            Text(text)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.white.opacity(0.84))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical, 9)
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white.opacity(0.035))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(accent.opacity(0.20), lineWidth: 1)
        }
    }
}

struct BucketDrillExecutionTracker: View {
    let drill: BucketPlanDrill
    let state: BucketDrillExecutionState
    let onStartTimer: () -> Void
    let onPauseTimer: () -> Void
    let onResetTimer: () -> Void
    let onIncrementReps: () -> Void
    let onDecrementReps: () -> Void
    let onResetReps: () -> Void

    private var configuration: BucketDrillExecutionConfiguration {
        drill.executionConfiguration
    }

    var body: some View {
        switch configuration.mode {
        case .timed:
            timedTracker
        case .manualReps:
            manualRepTracker
        case .openPractice:
            openPracticeTracker
        }
    }

    private var timedTracker: some View {
        let durationSeconds = configuration.durationSeconds ?? 0
        let remainingSeconds = max(0, durationSeconds - state.elapsedSeconds)

        return trackerSurface(accent: timedAccent) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .center, spacing: 10) {
                    trackerModeLabel("Timed", symbolName: "timer", color: timedAccent)
                    Spacer(minLength: 12)
                    statusPill(state.timedStatus.label, color: timedAccent)
                }

                Text(formattedTime(remainingSeconds))
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .monospacedDigit()
                    .lineLimit(1)
                    .minimumScaleFactor(0.74)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(alignment: .center, spacing: 10) {
                    if state.timedStatus == .running {
                        primaryTrackerButton("Pause", symbolName: "pause.fill", action: onPauseTimer)
                    } else {
                        primaryTrackerButton(state.elapsedSeconds > 0 ? "Resume" : "Start", symbolName: "play.fill", action: onStartTimer)
                    }

                    secondaryTrackerButton("Reset", symbolName: "arrow.counterclockwise", action: onResetTimer)
                }
            }
        }
    }

    private var manualRepTracker: some View {
        let profileLabel = drill.visualProfile?.trackerLabel
        let targetText = configuration.targetReps.map { target in
            if let profileLabel {
                return "\(profileLabel) • Target \(target)"
            }

            return "Target \(target)"
        } ?? (profileLabel ?? "No target")

        return trackerSurface(accent: GarageTheme.accentGreen) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .center, spacing: 10) {
                    trackerModeLabel("Live Tracker", symbolName: "plus.forwardslash.minus", color: GarageTheme.accentGreen)
                    Spacer(minLength: 12)
                    Text(targetText)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(GarageTheme.textSecondary)
                        .lineLimit(1)
                }

                HStack(alignment: .lastTextBaseline, spacing: 8) {
                    Text("\(state.repCount)")
                        .font(.system(size: 52, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .monospacedDigit()
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)

                    Text("recorded")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(GarageTheme.textSecondary)
                }

                primaryTrackerButton(drill.successActionTitle, symbolName: "plus", action: onIncrementReps)

                HStack(spacing: 10) {
                    secondaryTrackerButton(drill.correctionActionTitle, symbolName: "minus", action: onDecrementReps)
                    tertiaryTrackerButton("Reset", symbolName: "arrow.counterclockwise", action: onResetReps)
                }
            }
        }
    }

    private var openPracticeTracker: some View {
        VStack(alignment: .leading, spacing: 9) {
            trackerModeLabel("Open Practice", symbolName: "figure.golf", color: GarageTheme.textSecondary)

            Text("Execute deliberately, then advance when the rep feels complete.")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white.opacity(0.86))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.leading, 12)
                .overlay(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 1, style: .continuous)
                        .fill(GarageTheme.textSecondary.opacity(0.45))
                        .frame(width: 2)
                }
        }
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var timedAccent: Color {
        switch state.timedStatus {
        case .running:
            GarageTheme.accentGreen
        case .completed:
            GarageTheme.accentBlue
        case .idle, .paused:
            GarageTheme.textSecondary
        }
    }

    private func trackerSurface<Content: View>(
        accent: Color,
        @ViewBuilder content: () -> Content
    ) -> some View {
        content()
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(GarageTheme.panelFill)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(accent.opacity(0.28), lineWidth: 1)
                    )
            )
    }

    private func trackerModeLabel(_ title: String, symbolName: String, color: Color) -> some View {
        Label(title, systemImage: symbolName)
            .font(.caption.weight(.semibold))
            .tracking(1.1)
            .textCase(.uppercase)
            .foregroundStyle(color)
            .lineLimit(1)
    }

    private func statusPill(_ title: String, color: Color) -> some View {
        Text(title)
            .font(.caption.weight(.semibold))
            .tracking(0.8)
            .foregroundStyle(color)
            .lineLimit(1)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                Capsule()
                    .fill(color.opacity(0.12))
                    .overlay(Capsule().stroke(color.opacity(0.18), lineWidth: 1))
            )
    }

    private func primaryTrackerButton(_ title: String, symbolName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(title, systemImage: symbolName)
                .font(.headline.weight(.heavy))
                .tracking(0.2)
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.86)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(
                    LinearGradient(
                        colors: [GarageTheme.accentGreen, Color(red: 0.02, green: 0.42, blue: 0.28)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .clipShape(Capsule())
                .shadow(color: GarageTheme.accentGreen.opacity(0.20), radius: 12, x: 0, y: 7)
        }
        .buttonStyle(.plain)
    }

    private func secondaryTrackerButton(_ title: String, symbolName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(title, systemImage: symbolName)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white.opacity(0.84))
                .lineLimit(1)
                .minimumScaleFactor(0.86)
                .frame(maxWidth: .infinity)
                .frame(height: 38)
                .background(.white.opacity(0.08))
                .clipShape(Capsule())
                .overlay {
                    Capsule()
                        .stroke(.white.opacity(0.13), lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
    }

    private func tertiaryTrackerButton(_ title: String, symbolName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(title, systemImage: symbolName)
                .font(.subheadline.weight(.semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.86)
                .frame(maxWidth: .infinity)
                .frame(height: 38)
                .background(.white.opacity(0.04))
                .clipShape(Capsule())
                .overlay {
                    Capsule()
                        .stroke(GarageTheme.border, lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
        .foregroundStyle(GarageTheme.textSecondary)
    }

    private func formattedTime(_ seconds: Int) -> String {
        "\(seconds / 60):\(String(format: "%02d", seconds % 60))"
    }
}

private extension BucketTimedExecutionStatus {
    var label: String {
        switch self {
        case .idle:
            "Ready"
        case .running:
            "Running"
        case .paused:
            "Paused"
        case .completed:
            "Complete"
        }
    }
}

struct BucketActiveActionBar: View {
    let canGoPrevious: Bool
    let isFinalDrill: Bool
    let onPrevious: () -> Void
    let onAdvance: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            Button(action: onPrevious) {
                Label("Previous", systemImage: "chevron.left")
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.86)
                    .frame(maxWidth: .infinity)
                    .frame(height: 46)
                    .background(.white.opacity(canGoPrevious ? 0.08 : 0.035))
                    .clipShape(Capsule())
                    .overlay {
                        Capsule()
                            .stroke(GarageTheme.border, lineWidth: 1)
                    }
            }
            .buttonStyle(.plain)
            .foregroundStyle(canGoPrevious ? .white.opacity(0.84) : GarageTheme.textSecondary.opacity(0.55))
            .disabled(!canGoPrevious)

            Button(action: onAdvance) {
                Label(isFinalDrill ? "Finish Session" : "Next Drill", systemImage: isFinalDrill ? "flag.checkered" : "forward.fill")
                    .font(.headline.weight(.heavy))
                    .lineLimit(1)
                    .minimumScaleFactor(0.82)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 46)
                    .background(
                        LinearGradient(
                            colors: [GarageTheme.accentBlue, Color(red: 0.08, green: 0.28, blue: 0.68)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .clipShape(Capsule())
                    .shadow(color: GarageTheme.accentBlue.opacity(0.22), radius: 12, x: 0, y: 7)
            }
            .buttonStyle(.plain)
        }
    }
}
