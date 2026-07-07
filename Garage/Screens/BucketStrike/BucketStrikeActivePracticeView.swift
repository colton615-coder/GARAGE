import SwiftUI

struct BucketActivePracticeView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var session: BucketActiveSessionState
    @State private var isEndSessionConfirmationPresented = false
    @State private var isInstructionPanelPresented = false
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
                .padding(.bottom, 104)
            }
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
            if presentationPhase == .active,
               session.currentExecutionState.timedStatus == .completed {
                presentationPhase = .drillComplete
            }
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
                onIncrementReps: recordManualSuccess,
                onDecrementReps: { session.decrementCurrentReps() },
                onResetReps: { session.resetCurrentReps() },
                onPrevious: moveToPreviousDrill,
                onComplete: { presentationPhase = .drillComplete },
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

    private func recordManualSuccess() {
        session.incrementCurrentReps()
        guard let targetReps = session.currentDrill.executionConfiguration.targetReps else { return }
        if session.currentExecutionState.repCount >= targetReps {
            presentationPhase = .drillComplete
        }
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
            "Read the task, then execute."
        case .active:
            session.currentDrill.compactExecutionText
        case .drillComplete:
            "Nice work."
        case .nextDrillPreview:
            "Preview the next task before tracking."
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .center, spacing: 14) {
                Button(action: onEnd) {
                    Text("End")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.red.opacity(0.92))
                        .frame(width: 96, height: 54)
                        .background(.black.opacity(0.18))
                        .clipShape(Capsule())
                        .overlay {
                            Capsule()
                                .stroke(.white.opacity(0.18), lineWidth: 1)
                        }
                }
                .buttonStyle(.plain)

                Image(systemName: phase == .drillComplete ? "checkmark.circle" : "target")
                    .font(.system(size: 34, weight: .semibold))
                    .foregroundStyle(GarageTheme.accentGreen)
                    .frame(width: 48, height: 48)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 5) {
                    Text(eyebrow)
                        .font(.system(size: 26, weight: .heavy, design: .monospaced))
                        .foregroundStyle(.white)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(subtitle)
                        .font(.headline.weight(.medium))
                        .foregroundStyle(GarageTheme.accentGreen)
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
        .padding(.vertical, 12)
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

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            BucketVisualizationWorkspace(drill: drill)
                .frame(maxWidth: .infinity)

            VStack(alignment: .leading, spacing: 10) {
                Text("STEP \(drillNumber) OF \(drillCount)")
                    .font(.system(size: 14, weight: .heavy, design: .monospaced))
                    .tracking(1.2)
                    .foregroundStyle(GarageTheme.accentGreen)

                Text(drill.setupTitle)
                    .font(.system(size: 36, weight: .heavy, design: .monospaced))
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)

                Text(drill.setupInstructionText)
                    .font(.title3.weight(.regular))
                    .foregroundStyle(.white.opacity(0.84))
                    .lineSpacing(5)
                    .fixedSize(horizontal: false, vertical: true)
            }

            BucketTeachingMetadataGrid(drill: drill)

            if let whyText = drill.whyItMattersText {
                BucketEditorialTeachingBlock(
                    title: "Why It Matters",
                    text: whyText,
                    symbolName: "lightbulb"
                )
            }

            BucketPrimaryCapsuleButton(
                title: drill.startButtonTitle,
                symbolName: "play.circle",
                action: onStart
            )

            BucketSecondaryCapsuleButton(
                title: "Drill Intel",
                symbolName: "info.circle",
                action: onShowIntel
            )
        }
        .padding(24)
        .background(BucketActiveSurface())
    }
}

struct BucketActiveExecutionView: View {
    let drill: BucketPlanDrill
    let state: BucketDrillExecutionState
    let canGoPrevious: Bool
    let isFinalDrill: Bool
    let onStartTimer: () -> Void
    let onPauseTimer: () -> Void
    let onResetTimer: () -> Void
    let onIncrementReps: () -> Void
    let onDecrementReps: () -> Void
    let onResetReps: () -> Void
    let onPrevious: () -> Void
    let onComplete: () -> Void
    let onShowIntel: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            BucketVisualizationWorkspace(drill: drill)

            BucketEditorialTeachingBlock(
                title: "Do This",
                text: drill.compactExecutionText,
                symbolName: "scope"
            )

            BucketEditorialTeachingBlock(
                title: "Focus",
                text: drill.focusText,
                symbolName: "target"
            )

            BucketDrillExecutionTracker(
                drill: drill,
                state: state,
                onStartTimer: onStartTimer,
                onPauseTimer: onPauseTimer,
                onResetTimer: onResetTimer,
                onIncrementReps: onIncrementReps,
                onDecrementReps: onDecrementReps,
                onResetReps: onResetReps
            )

            VStack(spacing: 10) {
                HStack(spacing: 10) {
                    BucketSecondaryCapsuleButton(
                        title: "Previous Drill",
                        symbolName: "chevron.left",
                        isEnabled: canGoPrevious,
                        action: onPrevious
                    )

                    BucketSecondaryCapsuleButton(
                        title: "Drill Intel",
                        symbolName: "info.circle",
                        action: onShowIntel
                    )
                }

                BucketSecondaryCapsuleButton(
                    title: isFinalDrill ? "Finish Drill" : "Complete Drill",
                    symbolName: isFinalDrill ? "checkmark.circle" : "arrow.right.circle",
                    action: onComplete
                )
            }
        }
        .padding(24)
        .background(BucketActiveSurface())
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
                if let target = drill.executionConfiguration.targetReps {
                    return "\(state.repCount) of \(target) \(visualProfile.trackerLabel.lowercased()) recorded."
                }
                return "\(state.repCount) \(visualProfile.trackerLabel.lowercased()) recorded."
            }

            if let target = drill.executionConfiguration.targetReps {
                return "\(state.repCount) of \(target) recorded."
            }
            return "\(state.repCount) reps recorded."
        case .timed:
            let elapsed = state.elapsedSeconds
            if let visualProfile = drill.visualProfile {
                return "\(elapsed / 60):\(String(format: "%02d", elapsed % 60)) \(visualProfile.trackerLabel.lowercased()) completed."
            }
            return "\(elapsed / 60):\(String(format: "%02d", elapsed % 60)) completed."
        case .openPractice:
            return "Drill marked complete."
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: "checkmark.circle")
                    .font(.system(size: 42, weight: .semibold))
                    .foregroundStyle(GarageTheme.accentGreen)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Drill Complete")
                        .font(.system(size: 28, weight: .heavy, design: .monospaced))
                        .foregroundStyle(.white)

                    Text(completionText)
                        .font(.headline.weight(.medium))
                        .foregroundStyle(GarageTheme.textSecondary)
                }
            }

            Divider()
                .overlay(GarageTheme.divider)

            BucketEditorialTeachingBlock(
                title: "Recap",
                text: drill.completionRecapText,
                symbolName: "trophy"
            )

            BucketEditorialTeachingBlock(
                title: "Carry Forward",
                text: drill.carryForwardText,
                symbolName: "arrow.forward.circle"
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
        .padding(24)
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
        VStack(alignment: .leading, spacing: 18) {
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
                    .font(.system(size: 36, weight: .heavy, design: .monospaced))
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)
            }

            BucketVisualizationWorkspace(drill: drill)

            Text(drill.setupInstructionText)
                .font(.title3.weight(.regular))
                .foregroundStyle(.white.opacity(0.84))
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)

            BucketTeachingMetadataGrid(drill: drill)

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
        .padding(24)
        .background(BucketActiveSurface())
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

struct BucketActivePracticeCard: View {
    let drill: BucketPlanDrill
    let state: BucketDrillExecutionState
    let canGoPrevious: Bool
    let isFinalDrill: Bool
    let onStartTimer: () -> Void
    let onPauseTimer: () -> Void
    let onResetTimer: () -> Void
    let onIncrementReps: () -> Void
    let onDecrementReps: () -> Void
    let onResetReps: () -> Void
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
                onResetTimer: onResetTimer,
                onIncrementReps: onIncrementReps,
                onDecrementReps: onDecrementReps,
                onResetReps: onResetReps
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
