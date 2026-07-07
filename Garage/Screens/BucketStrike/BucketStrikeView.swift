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

