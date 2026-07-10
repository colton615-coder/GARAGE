import SwiftUI

struct BucketActivePracticeView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var session: BucketActiveSessionState
    @State private var isEndSessionConfirmationPresented = false
    @State private var isInstructionPanelPresented = false
    @State private var isResultEntryPresented = false
    @State private var pendingSucceeded = 0
    @State private var presentationPhase: BucketActivePresentationPhase = .setup

    init(plan: BucketPracticePlan) {
        _session = State(initialValue: BucketActiveSessionState(planSnapshot: plan))
    }

    var body: some View {
        Group {
            switch session.status {
            case .active:
                activeContent
            case .completed:
                BucketSessionCompleteView(plan: session.planSnapshot) {
                    dismiss()
                }
            }
        }
        .background(GarageTheme.background.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .confirmationDialog(
            "End this session?",
            isPresented: $isEndSessionConfirmationPresented,
            titleVisibility: .visible
        ) {
            Button("End Session", role: .destructive) {
                session.stopAllTimers()
                dismiss()
            }

            Button("Keep Practicing", role: .cancel) {}
        } message: {
            Text("This will leave the active practice flow without saving a session result.")
        }
        .sheet(isPresented: $isResultEntryPresented) {
            BucketResultEntryView(
                drill: session.currentDrill,
                succeeded: $pendingSucceeded,
                isFinalDrill: session.isFinalDrill,
                onConfirm: confirmCurrentResult
            )
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
    }

    private var activeContent: some View {
        ZStack(alignment: .bottom) {
            BucketSpatialPracticeBackground()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    BucketActiveTopBar(
                        session: session,
                        phase: presentationPhase,
                        onEnd: requestEndSession
                    )
                    .padding(.top, 14)

                    phaseContent
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 28)
            }
            .id(session.currentDrill.id)
            .scrollContentBackground(.hidden)

            if isInstructionPanelPresented {
                BucketInstructionOverlaySheet(
                    drill: session.currentDrill,
                    isPresented: $isInstructionPanelPresented
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .zIndex(2)
            }
        }
        .animation(.spring(response: 0.34, dampingFraction: 0.86), value: isInstructionPanelPresented)
        .animation(.spring(response: 0.34, dampingFraction: 0.88), value: presentationPhase)
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            session.tickCurrentTimer()
        }
        .onDisappear {
            session.stopAllTimers()
        }
    }

    @ViewBuilder
    private var phaseContent: some View {
        switch presentationPhase {
        case .setup:
            BucketSetupTeachingView(
                drill: session.currentDrill,
                drillNumber: session.currentDrillNumber,
                drillCount: session.drillCount,
                onStart: beginCurrentDrill,
                onShowIntel: { isInstructionPanelPresented = true }
            )
        case .active:
            BucketActiveExecutionView(
                drill: session.currentDrill,
                state: session.currentExecutionState,
                canGoPrevious: session.canGoPrevious,
                isFinalDrill: session.isFinalDrill,
                onStartTimer: { session.startCurrentTimer() },
                onPauseTimer: { session.pauseCurrentTimer() },
                onResetTimer: { session.resetCurrentTimer() },
                onPrevious: moveToPreviousDrill,
                onLogResult: presentResultEntry,
                onShowIntel: { isInstructionPanelPresented = true }
            )
        case .drillComplete:
            BucketDrillCompleteView(
                drill: session.currentDrill,
                state: session.currentExecutionState,
                isFinalDrill: session.isFinalDrill,
                onContinue: continueAfterDrillComplete,
                onReview: { presentationPhase = .setup }
            )
        case .nextDrillPreview:
            BucketNextDrillPreviewView(
                drill: session.currentDrill,
                previousDrill: previousCompletedDrill,
                drillNumber: session.currentDrillNumber,
                drillCount: session.drillCount,
                onStart: beginCurrentDrill,
                onReviewSetup: { presentationPhase = .setup }
            )
        }
    }

    private var previousCompletedDrill: BucketPlanDrill? {
        guard session.currentDrillIndex > 0 else { return nil }
        return session.planSnapshot.drills[session.currentDrillIndex - 1]
    }

    private func requestEndSession() {
        session.stopCurrentTimer()
        isEndSessionConfirmationPresented = true
    }

    private func beginCurrentDrill() {
        if session.currentDrill.executionConfiguration.mode == .timed {
            session.startCurrentTimer()
        }
        presentationPhase = .active
    }

    private func presentResultEntry() {
        pendingSucceeded = session.currentExecutionState.succeeded > 0
            ? session.currentExecutionState.succeeded
            : session.currentExecutionState.target
        isResultEntryPresented = true
    }

    private func confirmCurrentResult() {
        session.captureCurrentResult(
            succeeded: pendingSucceeded,
            attempted: session.currentExecutionState.target
        )
        isResultEntryPresented = false
        presentationPhase = .drillComplete
    }

    private func moveToPreviousDrill() {
        session.previousDrill()
        presentationPhase = .setup
    }

    private func continueAfterDrillComplete() {
        if session.isFinalDrill {
            session.advance()
        } else {
            session.advance()
            presentationPhase = .nextDrillPreview
        }
    }
}

struct BucketActiveTopBar: View {
    let session: BucketActiveSessionState
    let phase: BucketActivePresentationPhase
    let onEnd: () -> Void

    private var eyebrow: String {
        switch phase {
        case .setup:
            "DRILL \(session.currentDrillNumber) SETUP"
        case .active:
            "DRILL \(session.currentDrillNumber) ACTIVE"
        case .drillComplete:
            "DRILL \(session.currentDrillNumber) COMPLETE"
        case .nextDrillPreview:
            "UP NEXT: DRILL \(session.currentDrillNumber) OF \(session.drillCount)"
        }
    }

    private var subtitle: String {
        switch phase {
        case .setup:
            session.currentDrill.primaryCueText
        case .active:
            session.currentDrill.compactExecutionText
        case .drillComplete:
            session.currentDrill.carryForwardText
        case .nextDrillPreview:
            session.currentDrill.primaryCueText
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center, spacing: 14) {
                Button(action: onEnd) {
                    Label("End", systemImage: "xmark")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.red.opacity(0.92))
                        .frame(width: 78, height: 42)
                        .background(.black.opacity(0.12))
                        .clipShape(Capsule())
                        .overlay {
                            Capsule()
                                .stroke(.white.opacity(0.12), lineWidth: 1)
                        }
                }
                .buttonStyle(.plain)

                Image(systemName: phase == .drillComplete ? "checkmark.circle" : "target")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(GarageTheme.accentGreen)
                    .frame(width: 34, height: 34)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 5) {
                    Text(eyebrow)
                        .font(.system(size: 15, weight: .heavy, design: .monospaced))
                        .tracking(0.9)
                        .foregroundStyle(.white)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(subtitle)
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(GarageTheme.textSecondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 0)
            }

            BucketFloatingActiveHeader(session: session)
        }
    }
}

struct BucketSpatialPracticeBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.04, green: 0.07, blue: 0.06),
                    Color(red: 0.09, green: 0.12, blue: 0.10),
                    Color(red: 0.02, green: 0.03, blue: 0.03)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Rectangle()
                .fill(.ultraThinMaterial)
                .blur(radius: 20, opaque: true)
                .opacity(0.42)

            VStack(spacing: 0) {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [.white.opacity(0.06), .clear],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: 260)

                Spacer()
            }
        }
        .ignoresSafeArea()
    }
}

struct BucketFloatingActiveHeader: View {
    let session: BucketActiveSessionState

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline, spacing: 12) {
                Text(session.currentDrill.displayTitle)
                    .font(.headline.weight(.heavy))
                    .tracking(0.3)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.78)

                Spacer(minLength: 10)

                Text("Drill \(session.currentDrillNumber)/\(session.drillCount)")
                    .font(.caption.weight(.bold))
                    .tracking(0.8)
                    .foregroundStyle(GarageTheme.accentGreen)
                    .lineLimit(1)
            }

            ProgressView(value: session.progressValue)
                .tint(GarageTheme.accentGreen)
                .scaleEffect(x: 1, y: 0.72, anchor: .center)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(.white.opacity(0.10), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.12), radius: 14, x: 0, y: 8)
    }
}

struct BucketSetupTeachingView: View {
    let drill: BucketPlanDrill
    let drillNumber: Int
    let drillCount: Int
    let onStart: () -> Void
    let onShowIntel: () -> Void
    @State private var completedSteps: Set<String> = []

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Preflight \(drillNumber)/\(drillCount)")
                        .font(.caption.weight(.bold))
                        .tracking(1.4)
                        .textCase(.uppercase)
                        .foregroundStyle(GarageTheme.accentGreen)

                    Text(drill.setupTitle)
                        .font(.title2.weight(.bold))
                        .foregroundStyle(.white)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 12)

                Button(action: onShowIntel) {
                    Image(systemName: "info.circle")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(GarageTheme.accentGreen)
                        .frame(width: 42, height: 42)
                        .background(.white.opacity(0.045), in: Circle())
                        .overlay {
                            Circle()
                                .stroke(GarageTheme.border, lineWidth: 1)
                        }
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Drill Intel")
            }

            BucketVisualizationWorkspace(
                drill: drill,
                showsCallouts: true,
                caption: drill.primaryCueText
            )

            BucketSetupSectionHeader(title: "Setup", symbolName: "list.bullet")

            VStack(spacing: 10) {
                ForEach(drill.setupStepTexts, id: \.self) { step in
                    setupChecklistRow(step)
                }
            }

            BucketSetupSectionHeader(title: "What to Watch", symbolName: "eye")

            VStack(alignment: .leading, spacing: 10) {
                watchRow(symbolName: "target", text: drill.focusText)
                watchRow(symbolName: "chart.bar", text: drill.goalText)
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

    private func setupChecklistRow(_ step: String) -> some View {
        let isComplete = completedSteps.contains(step)

        return Button {
            if isComplete {
                completedSteps.remove(step)
            } else {
                completedSteps.insert(step)
            }
        } label: {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: isComplete ? "checkmark.circle.fill" : "circle")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(isComplete ? GarageTheme.accentGreen : .white.opacity(0.35))
                    .accessibilityHidden(true)

                Text(step)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.white.opacity(isComplete ? 0.55 : 0.82))
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: 0)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: isComplete)
        .accessibilityValue(isComplete ? "Done" : "Not done")
    }

    private func watchRow(symbolName: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: symbolName)
                .font(.caption.weight(.heavy))
                .foregroundStyle(GarageTheme.accentGreen)
                .frame(width: 18, height: 18)
                .accessibilityHidden(true)

            Text(text)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.white.opacity(0.82))
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)
        }
    }
}

struct BucketSetupSectionHeader: View {
    let title: String
    let symbolName: String

    var body: some View {
        Label(title, systemImage: symbolName)
            .font(.caption.weight(.bold))
            .tracking(1.2)
            .textCase(.uppercase)
            .foregroundStyle(GarageTheme.accentGreen)
    }
}

struct BucketActiveExecutionView: View {
    let drill: BucketPlanDrill
    let state: BucketDrillExecutionState
    let canGoPrevious: Bool
    let isFinalDrill: Bool
    var onStartTimer: () -> Void = {}
    var onPauseTimer: () -> Void = {}
    var onResetTimer: () -> Void = {}
    let onPrevious: () -> Void
    let onLogResult: () -> Void
    let onShowIntel: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 6) {
                Text(drill.displayTitle)
                    .font(.system(size: 24, weight: .heavy, design: .monospaced))
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)

                Text(drill.compactExecutionText)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(GarageTheme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            BucketVisualizationWorkspace(drill: drill)

            BucketDrillExecutionTracker(
                drill: drill,
                state: state,
                onStartTimer: onStartTimer,
                onPauseTimer: onPauseTimer,
                onResetTimer: onResetTimer
            )

            if drill.executionConfiguration.mode == .manualReps {
                BucketEditorialTeachingBlock(
                    title: "Target",
                    text: "Target: \(state.target)",
                    symbolName: "number.circle"
                )
            }

            BucketEditorialTeachingBlock(
                title: "Focus",
                text: drill.primaryCueText,
                symbolName: "target"
            )

            BucketPrimaryCapsuleButton(
                title: "Log Result",
                symbolName: "square.and.pencil",
                action: onLogResult
            )

            HStack(spacing: 10) {
                BucketQuietCapsuleButton(
                    title: "Previous",
                    symbolName: "chevron.left",
                    isEnabled: canGoPrevious,
                    action: onPrevious
                )

                BucketQuietCapsuleButton(
                    title: "Intel",
                    symbolName: "info.circle",
                    action: onShowIntel
                )
            }
        }
        .padding(18)
        .background(BucketActiveSurface())
    }
}

struct BucketResultEntryView: View {
    let drill: BucketPlanDrill
    @Binding var succeeded: Int
    let isFinalDrill: Bool
    let onConfirm: () -> Void

    private var target: Int {
        drill.resultTarget
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Log Result")
                    .font(.system(size: 24, weight: .heavy, design: .monospaced))
                    .foregroundStyle(.white)

                Text(drill.displayTitle)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(GarageTheme.textSecondary)
                    .lineLimit(2)
            }

            VStack(alignment: .leading, spacing: 12) {
                Text(drill.resultSuccessLabel)
                    .font(.caption.weight(.bold))
                    .tracking(1.2)
                    .textCase(.uppercase)
                    .foregroundStyle(GarageTheme.accentGreen)

                HStack(alignment: .center, spacing: 14) {
                    resultStepButton(symbolName: "minus") {
                        succeeded = max(0, succeeded - 1)
                    }
                    .disabled(succeeded <= 0)

                    VStack(spacing: 2) {
                        Text("\(succeeded)")
                            .font(.system(size: 64, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .monospacedDigit()
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)

                        Text("of \(target)")
                            .font(.headline.weight(.semibold))
                            .foregroundStyle(GarageTheme.textSecondary)
                    }
                    .frame(maxWidth: .infinity)

                    resultStepButton(symbolName: "plus") {
                        succeeded = min(target, succeeded + 1)
                    }
                    .disabled(succeeded >= target)
                }

                Stepper(
                    value: $succeeded,
                    in: 0...target,
                    step: 1
                ) {
                    Text(drill.resultSuccessLabel)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.84))
                }
            }
            .padding(16)
            .background(BucketActiveSurface())

            BucketPrimaryCapsuleButton(
                title: isFinalDrill ? "Finish Drill" : "Next Drill",
                symbolName: isFinalDrill ? "checkmark.circle" : "arrow.right.circle",
                action: onConfirm
            )
        }
        .padding(18)
        .background(GarageTheme.background.ignoresSafeArea())
        .onAppear {
            succeeded = min(max(0, succeeded), target)
        }
    }

    private func resultStepButton(symbolName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: symbolName)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.black.opacity(0.84))
                .frame(width: 72, height: 72)
                .background(GarageTheme.accentGreen)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
}

struct BucketDrillCompleteView: View {
    let drill: BucketPlanDrill
    let state: BucketDrillExecutionState
    let isFinalDrill: Bool
    let onContinue: () -> Void
    let onReview: () -> Void

    private var completionText: String {
        switch drill.executionConfiguration.mode {
        case .manualReps:
            if let visualProfile = drill.visualProfile {
                return "\(state.succeeded) of \(state.attempted) \(visualProfile.trackerLabel.lowercased()) recorded."
            }

            return "\(state.succeeded) of \(state.attempted) recorded."
        case .timed:
            let elapsed = state.elapsedSeconds
            if let visualProfile = drill.visualProfile {
                return "\(state.succeeded) of \(state.attempted) \(visualProfile.trackerLabel.lowercased()) recorded in \(elapsed / 60):\(String(format: "%02d", elapsed % 60))."
            }
            return "\(state.succeeded) of \(state.attempted) recorded in \(elapsed / 60):\(String(format: "%02d", elapsed % 60))."
        case .openPractice:
            return "\(state.succeeded) of \(state.attempted) recorded."
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: "checkmark.circle")
                    .font(.system(size: 34, weight: .semibold))
                    .foregroundStyle(GarageTheme.accentGreen)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Drill Complete")
                        .font(.system(size: 24, weight: .heavy, design: .monospaced))
                        .foregroundStyle(.white)

                    Text(completionText)
                        .font(.headline.weight(.medium))
                        .foregroundStyle(GarageTheme.textSecondary)
                }
            }

            Divider()
                .overlay(GarageTheme.divider)

            BucketEditorialTeachingBlock(
                title: "Carry Forward",
                text: drill.carryForwardText,
                symbolName: "arrow.forward.circle"
            )

            BucketEditorialTeachingBlock(
                title: "Recap",
                text: drill.completionRecapText,
                symbolName: "trophy"
            )

            BucketPrimaryCapsuleButton(
                title: isFinalDrill ? "Finish Session" : "Continue",
                symbolName: isFinalDrill ? "checkmark.circle" : "arrow.right.circle",
                action: onContinue
            )

            BucketSecondaryCapsuleButton(
                title: "Review Setup",
                symbolName: "eye",
                action: onReview
            )
        }
        .padding(18)
        .background(BucketActiveSurface())
    }
}

struct BucketNextDrillPreviewView: View {
    let drill: BucketPlanDrill
    let previousDrill: BucketPlanDrill?
    let drillNumber: Int
    let drillCount: Int
    let onStart: () -> Void
    let onReviewSetup: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let previousDrill {
                HStack(spacing: 12) {
                    Image(systemName: "checkmark.circle")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(GarageTheme.accentGreen)
                        .accessibilityHidden(true)

                    Text("Completed \(previousDrill.displayTitle).")
                        .font(.body.weight(.medium))
                        .foregroundStyle(.white.opacity(0.82))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("UP NEXT: DRILL \(drillNumber) OF \(drillCount)")
                    .font(.system(size: 14, weight: .heavy, design: .monospaced))
                    .tracking(1.2)
                    .foregroundStyle(GarageTheme.accentGreen)

                Text(drill.displayTitle)
                    .font(.system(size: 30, weight: .heavy, design: .monospaced))
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)
            }

            BucketEditorialTeachingBlock(
                title: "Setup",
                text: drill.setupStepTexts.joined(separator: " "),
                symbolName: "list.bullet"
            )

            BucketEditorialTeachingBlock(
                title: "Cue",
                text: drill.primaryCueText,
                symbolName: "target"
            )

            BucketPrimaryCapsuleButton(
                title: "Start Drill \(drillNumber)",
                symbolName: "play.circle",
                action: onStart
            )

            BucketSecondaryCapsuleButton(
                title: "Review Setup",
                symbolName: "eye",
                action: onReviewSetup
            )
        }
        .padding(18)
        .background(BucketActiveSurface())
    }
}

struct BucketNumberedSetupStep: View {
    let number: Int
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 11) {
            Text("\(number)")
                .font(.caption.weight(.heavy))
                .foregroundStyle(.black.opacity(0.82))
                .frame(width: 24, height: 24)
                .background(GarageTheme.accentGreen)
                .clipShape(Circle())

            Text(text)
                .font(.body.weight(.medium))
                .foregroundStyle(.white.opacity(0.84))
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct BucketTeachingMetadataGrid: View {
    let drill: BucketPlanDrill

    var body: some View {
        VStack(spacing: 0) {
            BucketTeachingMetadataItem(
                title: "Focus",
                text: drill.focusText,
                symbolName: "target"
            )

            Divider()
                .overlay(GarageTheme.divider)

            BucketTeachingMetadataItem(
                title: "Distance",
                text: drill.distanceText,
                symbolName: "ruler"
            )

            Divider()
                .overlay(GarageTheme.divider)

            BucketTeachingMetadataItem(
                title: "Goal",
                text: drill.goalText,
                symbolName: "chart.bar"
            )
        }
        .padding(.horizontal, 14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.black.opacity(0.16))
                .overlay {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(.white.opacity(0.13), lineWidth: 1)
                }
        )
    }
}

struct BucketTeachingMetadataItem: View {
    let title: String
    let text: String
    let symbolName: String

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: symbolName)
                .font(.title3.weight(.semibold))
                .foregroundStyle(GarageTheme.accentGreen)
                .frame(width: 28)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 5) {
                Text(title.uppercased())
                    .font(.system(size: 12, weight: .heavy, design: .monospaced))
                    .tracking(1.0)
                    .foregroundStyle(GarageTheme.accentGreen)

                Text(text)
                    .font(.body.weight(.medium))
                    .foregroundStyle(.white.opacity(0.80))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct BucketEditorialTeachingBlock: View {
    let title: String
    let text: String
    let symbolName: String

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: symbolName)
                .font(.title3.weight(.semibold))
                .foregroundStyle(GarageTheme.accentGreen)
                .frame(width: 28)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 5) {
                Text(title.uppercased())
                    .font(.system(size: 12, weight: .heavy, design: .monospaced))
                    .tracking(1.0)
                    .foregroundStyle(GarageTheme.accentGreen)

                Text(text)
                    .font(.body.weight(.medium))
                    .foregroundStyle(.white.opacity(0.82))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct BucketActiveSurface: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 24, style: .continuous)
            .fill(Color.black.opacity(0.16))
            .overlay {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(.white.opacity(0.12), lineWidth: 1)
            }
    }
}

struct BucketPrimaryCapsuleButton: View {
    let title: String
    let symbolName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: symbolName)
                .font(.title3.weight(.heavy))
                .foregroundStyle(.black.opacity(0.88))
                .frame(maxWidth: .infinity)
                .frame(height: 64)
                .background(GarageTheme.accentGreen)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

struct BucketSecondaryCapsuleButton: View {
    let title: String
    let symbolName: String
    var isEnabled = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: symbolName)
                .font(.headline.weight(.semibold))
                .foregroundStyle(isEnabled ? GarageTheme.accentGreen : GarageTheme.textSecondary)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(.black.opacity(0.10))
                .clipShape(Capsule())
                .overlay {
                    Capsule()
                        .stroke((isEnabled ? GarageTheme.accentGreen : GarageTheme.textSecondary).opacity(isEnabled ? 0.82 : 0.20), lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
    }
}

struct BucketQuietCapsuleButton: View {
    let title: String
    let symbolName: String
    var isEnabled = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: symbolName)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(isEnabled ? .white.opacity(0.72) : GarageTheme.textSecondary.opacity(0.45))
                .frame(maxWidth: .infinity)
                .frame(height: 42)
                .background(.white.opacity(isEnabled ? 0.045 : 0.025))
                .clipShape(Capsule())
                .overlay {
                    Capsule()
                        .stroke(GarageTheme.border, lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
    }
}

extension BucketPlanDrill {
    var setupStepTexts: [String] {
        if let visualProfile {
            return [visualProfile.setupInstruction, visualProfile.secondaryInstruction, visualProfile.equipment]
                .compactMap { $0 }
                .filter { !$0.isEmpty }
                .prefix(3)
                .map { $0 }
        }

        return ([setup] + steps)
            .filter { !$0.isEmpty }
            .prefix(3)
            .map { $0 }
    }

    var primaryCueText: String {
        let cue = focusText.trimmingCharacters(in: .whitespacesAndNewlines)
        return cue.isEmpty ? compactExecutionText : cue
    }

    var resultTarget: Int {
        executionConfiguration.targetReps ?? 10
    }

    var resultSuccessLabel: String {
        let title = successActionTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else { return "Clean reps" }

        let words = title.split(separator: " ")
        guard let lastWord = words.last else { return "Clean reps" }
        let prefix = words.dropLast().joined(separator: " ")
        let pluralLastWord = lastWord.lowercased().hasSuffix("s") ? String(lastWord) : "\(lastWord)s"
        let pluralized = prefix.isEmpty ? pluralLastWord : "\(prefix) \(pluralLastWord)"
        return pluralized.prefix(1).uppercased() + pluralized.dropFirst().lowercased()
    }
}

struct BucketActivePracticeCard: View {
    let drill: BucketPlanDrill
    let state: BucketDrillExecutionState
    let canGoPrevious: Bool
    let isFinalDrill: Bool
    let onStartTimer: () -> Void
    let onPauseTimer: () -> Void
    let onResetTimer: () -> Void
    @Binding var isInstructionPanelPresented: Bool
    let onPrevious: () -> Void
    let onAdvance: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            BucketVisualizationWorkspace(drill: drill)

            BucketDrillIntelButton(isPresented: $isInstructionPanelPresented)

            BucketDrillExecutionTracker(
                drill: drill,
                state: state,
                onStartTimer: onStartTimer,
                onPauseTimer: onPauseTimer,
                onResetTimer: onResetTimer
            )

            BucketActiveActionBar(
                canGoPrevious: canGoPrevious,
                isFinalDrill: isFinalDrill,
                onPrevious: onPrevious,
                onAdvance: onAdvance
            )
        }
        .padding(14)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(.white.opacity(0.12), lineWidth: 1)
        }
        .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 16)
    }
}

struct BucketDrillIntelButton: View {
    @Binding var isPresented: Bool

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.34, dampingFraction: 0.86)) {
                isPresented.toggle()
            }
        } label: {
            HStack(spacing: 5) {
                Image(systemName: isPresented ? "chevron.down.circle" : "info.circle")
                    .font(.system(size: 12, weight: .bold))

                Text("DRILL INTEL")
                    .font(.system(size: 11, weight: .heavy, design: .monospaced))
                    .tracking(0.9)
            }
            .foregroundStyle(GarageTheme.accentGreen)
            .padding(.vertical, 7)
            .padding(.horizontal, 12)
            .background(.white.opacity(0.055))
            .clipShape(Capsule())
            .overlay {
                Capsule()
                    .stroke(GarageTheme.accentGreen.opacity(0.20), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity, alignment: .center)
        .accessibilityLabel(isPresented ? "Hide drill instructions" : "Show drill instructions")
    }
}
