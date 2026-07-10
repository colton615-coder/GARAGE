import SwiftUI

struct BucketStrikeView: View {
    @State private var store = BucketStrikeState()

    var body: some View {
        GarageScreen {
            VStack(alignment: .leading, spacing: 28) {
                GarageHeader(
                    title: "BucketStrike",
                    subtitle: "Build a focused practice session.",
                    trailingSymbol: "basket.fill"
                )

                practiceTypeSection
                sessionFocusSection
                planPreviewSection
                actionRow
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private var practiceTypeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            GarageSectionHeader(title: "Practice Type")
                .foregroundStyle(GarageTheme.accentBlue)

            Picker("Practice Type", selection: $store.selectedPracticeType) {
                ForEach(BucketPracticeType.allCases) { practiceType in
                    Text(practiceType.title)
                        .tag(practiceType)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: store.selectedPracticeType) { _, newValue in
                store.selectPracticeType(newValue)
            }
        }
    }

    private var sessionFocusSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            GarageSectionHeader(title: "Session Focus")
                .foregroundStyle(GarageTheme.accentBlue)

            HStack(spacing: 10) {
                ForEach(store.availableFocuses) { focus in
                    BucketFocusCard(
                        focus: focus,
                        isSelected: store.selectedFocus.id == focus.id
                    ) {
                        store.selectFocus(focus)
                    }
                }
            }
        }
    }

    private var planPreviewSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            GarageSectionHeader(title: "Session Plan Preview")
                .foregroundStyle(GarageTheme.accentBlue)

            BucketSummaryStrip(plan: store.previewPlan)

            VStack(spacing: 8) {
                ForEach(store.previewPlan.drills) { drill in
                    BucketDrillRow(drill: drill)
                }
            }
        }
    }

    private var actionRow: some View {
        HStack(spacing: 10) {
            NavigationLink {
                BucketEditPlanView(
                    originalPlan: store.curatedPlan,
                    currentPlan: store.previewPlan
                ) { editedPlan in
                    store.applyEditedPlan(editedPlan)
                }
            } label: {
                Label("Edit Plan", systemImage: "pencil")
                    .font(.headline.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
            }
            .buttonStyle(.bordered)
            .tint(GarageTheme.accentBlue)

            NavigationLink {
                BucketActivePracticeView(plan: store.previewPlan)
            } label: {
                Label("Start Practice", systemImage: "bolt.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
            }
            .buttonStyle(.borderedProminent)
            .tint(GarageTheme.accentBlue)
            .controlSize(.large)
        }
    }
}

#Preview {
    NavigationStack {
        BucketStrikeView()
    }
    .preferredColorScheme(.dark)
}

#Preview("BucketStrike Edit Plan") {
    NavigationStack {
        BucketEditPlanView(
            originalPlan: BucketPracticePlan.makeDisplayPlan(
                practiceType: .range,
                focus: BucketSessionFocus.focuses(for: .range)[0]
            ),
            currentPlan: BucketPracticePlan.makeDisplayPlan(
                practiceType: .range,
                focus: BucketSessionFocus.focuses(for: .range)[0]
            )
        ) { _ in }
    }
    .preferredColorScheme(.dark)
}

#Preview("BucketStrike Active Flow") {
    NavigationStack {
        BucketActivePracticeView(
            plan: BucketPracticePlan.makeDisplayPlan(
                practiceType: .range,
                focus: BucketSessionFocus.focuses(for: .range)[0]
            )
        )
    }
    .preferredColorScheme(.dark)
}

#Preview("BucketStrike Session Complete") {
    BucketSessionCompleteView(
        plan: BucketPracticePlan.makeDisplayPlan(
            practiceType: .range,
            focus: BucketSessionFocus.focuses(for: .range)[0]
        )
    ) {}
    .background(GarageTheme.background)
    .preferredColorScheme(.dark)
}

#Preview("BucketStrike Drill Intel") {
    BucketInstructionOverlayPreview()
        .preferredColorScheme(.dark)
}

private struct BucketInstructionOverlayPreview: View {
    @State private var isPresented = true

    var body: some View {
        ZStack {
            BucketSpatialPracticeBackground()

            BucketInstructionOverlaySheet(
                drill: BucketPracticePlan.makeDisplayPlan(
                    practiceType: .range,
                    focus: BucketSessionFocus.focuses(for: .range)[0]
                ).drills[0],
                isPresented: $isPresented
            )
        }
    }
}

#Preview("BucketStrike Setup Card") {
    BucketPreviewCanvas {
        BucketSetupTeachingView(
            drill: BucketPreviewContent.manualDrill,
            drillNumber: 1,
            drillCount: 4,
            onStart: {},
            onShowIntel: {}
        )
    }
    .preferredColorScheme(.dark)
}

#Preview("BucketStrike Active Manual") {
    BucketPreviewCanvas {
        BucketActiveExecutionView(
            drill: BucketPreviewContent.manualDrill,
            state: BucketPreviewContent.manualState,
            canGoPrevious: true,
            isFinalDrill: false,
            onPrevious: {},
            onLogResult: {},
            onShowIntel: {}
        )
    }
    .preferredColorScheme(.dark)
}

#Preview("BucketStrike Active Timed") {
    BucketPreviewCanvas {
        BucketActiveExecutionView(
            drill: BucketPreviewContent.timedDrill,
            state: BucketPreviewContent.timedState,
            canGoPrevious: true,
            isFinalDrill: false,
            onPrevious: {},
            onLogResult: {},
            onShowIntel: {}
        )
    }
    .preferredColorScheme(.dark)
}

#Preview("BucketStrike Drill Complete") {
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

#Preview("BucketStrike Next Drill") {
    BucketPreviewCanvas {
        BucketNextDrillPreviewView(
            drill: BucketPreviewContent.timedDrill,
            previousDrill: BucketPreviewContent.manualDrill,
            drillNumber: 2,
            drillCount: 4,
            onStart: {},
            onReviewSetup: {}
        )
    }
    .preferredColorScheme(.dark)
}

struct BucketPreviewCanvas<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            BucketSpatialPracticeBackground()

            ScrollView(showsIndicators: false) {
                content
                    .padding(16)
            }
        }
    }
}

enum BucketPreviewContent {
    static let plan = BucketPracticePlan.makeDisplayPlan(
        practiceType: .range,
        focus: BucketSessionFocus.focuses(for: .range)[0]
    )

    static var manualDrill: BucketPlanDrill {
        plan.drills.first { $0.executionConfiguration.mode == .manualReps } ?? plan.drills[0]
    }

    static var timedDrill: BucketPlanDrill {
        plan.drills.first { $0.executionConfiguration.mode == .timed } ?? plan.drills[0]
    }

    static var manualState: BucketDrillExecutionState {
        var state = BucketDrillExecutionState(target: manualDrill.resultTarget)
        state.captureResult(succeeded: 6)
        return state
    }

    static var timedState: BucketDrillExecutionState {
        var state = BucketDrillExecutionState(target: timedDrill.resultTarget)
        state.elapsedSeconds = 142
        state.timedStatus = .running
        return state
    }
}

#Preview("Home") {
    GarageHomeView()
        .preferredColorScheme(.dark)
}

#Preview("Tempo") {
    TempoView()
        .preferredColorScheme(.dark)
}

#Preview("Colt's Caddy") {
    ColtsCaddyView()
        .preferredColorScheme(.dark)
}
