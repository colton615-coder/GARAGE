import SwiftUI

struct BucketEditPlanView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var draftPlan: BucketPracticePlan
    @State private var editMode: EditMode = .active

    let originalPlan: BucketPracticePlan
    let onApply: (BucketPracticePlan) -> Void

    init(
        originalPlan: BucketPracticePlan,
        currentPlan: BucketPracticePlan,
        onApply: @escaping (BucketPracticePlan) -> Void
    ) {
        self.originalPlan = originalPlan
        self.onApply = onApply
        _draftPlan = State(initialValue: currentPlan)
    }

    var body: some View {
        List {
            Section {
                BucketEditSummary(plan: draftPlan)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
            }

            Section {
                ForEach(draftPlan.drills) { drill in
                    BucketEditableDrillRow(drill: drill) {
                        removeDrill(drill)
                    }
                    .listRowBackground(GarageTheme.backgroundRaised)
                }
                .onMove(perform: moveDrills)
                .onDelete(perform: removeDrills)
            } header: {
                Text("Drills")
            } footer: {
                Text("Reorder or remove drills from this draft. Changes are not saved until applied.")
                    .foregroundStyle(GarageTheme.textSecondary)
            }

            Section {
                Button {
                    resetPlan()
                } label: {
                    Label("Reset Plan", systemImage: "arrow.counterclockwise")
                        .font(.body.weight(.semibold))
                }
                .disabled(draftPlan.drills.map(\.id) == originalPlan.drills.map(\.id))
            }
            .listRowBackground(GarageTheme.backgroundRaised)
        }
        .scrollContentBackground(.hidden)
        .background(GarageTheme.background.ignoresSafeArea())
        .environment(\.editMode, $editMode)
        .navigationTitle("Edit Plan")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            Button {
                applyChanges()
            } label: {
                Label("Apply Changes", systemImage: "checkmark.circle.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
            }
            .buttonStyle(.borderedProminent)
            .tint(GarageTheme.accentBlue)
            .controlSize(.large)
            .disabled(draftPlan.drills.isEmpty)
            .padding(.horizontal, GarageTheme.pagePadding)
            .padding(.top, 10)
            .padding(.bottom, 10)
            .background(.ultraThinMaterial)
        }
    }

    private func moveDrills(from source: IndexSet, to destination: Int) {
        var drills = draftPlan.drills
        drills.move(fromOffsets: source, toOffset: destination)
        draftPlan = draftPlan.replacingDrills(drills)
    }

    private func removeDrills(at offsets: IndexSet) {
        var drills = draftPlan.drills
        drills.remove(atOffsets: offsets)
        draftPlan = draftPlan.replacingDrills(drills)
    }

    private func removeDrill(_ drill: BucketPlanDrill) {
        draftPlan = draftPlan.replacingDrills(
            draftPlan.drills.filter { $0.id != drill.id }
        )
    }

    private func resetPlan() {
        draftPlan = originalPlan
    }

    private func applyChanges() {
        onApply(draftPlan.replacingDrills(draftPlan.drills))
        dismiss()
    }
}

struct BucketEditSummary: View {
    let plan: BucketPracticePlan

    var body: some View {
        HStack(spacing: 16) {
            BucketEditMetric(value: "\(plan.minutes) min", label: "Duration", symbolName: "clock", color: GarageTheme.accentBlue)
            BucketEditMetric(value: "\(plan.balls) balls", label: "Balls", symbolName: "basket.fill", color: GarageTheme.accentGreen)
            BucketEditMetric(value: "\(plan.drills.count)", label: "Drills", symbolName: "list.number", color: GarageTheme.accentPurple)
        }
        .padding(14)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(GarageTheme.backgroundRaised)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(GarageTheme.border, lineWidth: 1)
                )
        )
    }
}

struct BucketEditMetric: View {
    let value: String
    let label: String
    let symbolName: String
    let color: Color

    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: symbolName)
                .font(.body.weight(.semibold))
                .foregroundStyle(color)
                .accessibilityHidden(true)

            Text(value)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Text(label.uppercased())
                .font(.caption2.weight(.semibold))
                .tracking(1.0)
                .foregroundStyle(GarageTheme.textSecondary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
    }
}

struct BucketEditableDrillRow: View {
    let drill: BucketPlanDrill
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Text("\(drill.order)")
                .font(.headline.weight(.bold))
                .foregroundStyle(drill.accent)
                .frame(width: 26)

            Image(systemName: drill.symbolName)
                .font(.title3.weight(.bold))
                .foregroundStyle(drill.accent)
                .frame(width: 34)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 3) {
                Text(drill.title)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.86)

                Text(drill.subtitle)
                    .font(.footnote)
                    .foregroundStyle(GarageTheme.textSecondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.86)
            }

            Spacer(minLength: 8)

            Button(role: .destructive, action: onRemove) {
                Image(systemName: "minus.circle.fill")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.red.opacity(0.84))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Remove \(drill.title)")

            Image(systemName: "line.3.horizontal")
                .font(.body.weight(.semibold))
                .foregroundStyle(.white.opacity(0.38))
                .accessibilityHidden(true)
        }
        .padding(.vertical, 8)
        .accessibilityElement(children: .combine)
    }
}

struct BucketFocusCard: View {
    let focus: BucketSessionFocus
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: focus.symbolName)
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(focus.accent)
                    .frame(height: 34)
                    .accessibilityHidden(true)

                VStack(spacing: 4) {
                    Text(focus.title)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.white)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.86)

                    Text(focus.subtitle)
                        .font(.caption)
                        .foregroundStyle(GarageTheme.textSecondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.86)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 126)
            .padding(.horizontal, 8)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(GarageTheme.backgroundRaised)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(isSelected ? focus.accent.opacity(0.85) : GarageTheme.border, lineWidth: isSelected ? 1.5 : 1)
                    )
            )
            .overlay(alignment: .topTrailing) {
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(focus.accent)
                        .padding(8)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(focus.title), \(focus.subtitle)")
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
    }
}

struct BucketSummaryStrip: View {
    let plan: BucketPracticePlan

    var body: some View {
        HStack(spacing: 0) {
            BucketMetric(symbolName: "clock", value: "\(plan.minutes) min", label: "Duration", color: GarageTheme.accentBlue)
            BucketMetric(symbolName: "basket.fill", value: "\(plan.balls) balls", label: "Total Balls", color: GarageTheme.accentGreen)
            BucketMetric(symbolName: "waveform.path.ecg", value: "\(plan.drills.count) drills", label: "Drills", color: GarageTheme.accentPurple)
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(GarageTheme.backgroundRaised)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(GarageTheme.border, lineWidth: 1)
                )
        )
    }
}

struct BucketMetric: View {
    let symbolName: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: symbolName)
                .font(.title3.weight(.semibold))
                .foregroundStyle(color)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.78)

                Text(label.uppercased())
                    .font(.caption2.weight(.semibold))
                    .tracking(1.1)
                    .foregroundStyle(GarageTheme.textSecondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct BucketDrillRow: View {
    let drill: BucketPlanDrill

    var body: some View {
        HStack(spacing: 12) {
            Text("\(drill.order)")
                .font(.title3.weight(.bold))
                .foregroundStyle(drill.accent)
                .frame(width: 28)

            Rectangle()
                .fill(GarageTheme.divider)
                .frame(width: 1, height: 42)

            Image(systemName: drill.symbolName)
                .font(.title.weight(.bold))
                .foregroundStyle(drill.accent)
                .frame(width: 38)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 3) {
                Text(drill.title)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.86)

                Text(drill.subtitle)
                    .font(.footnote)
                    .foregroundStyle(GarageTheme.textSecondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.86)
            }

            Spacer(minLength: 8)

            Image(systemName: "chevron.right")
                .font(.headline.weight(.semibold))
                .foregroundStyle(.white.opacity(0.46))
                .accessibilityHidden(true)
        }
        .padding(.horizontal, 14)
        .frame(height: 68)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(GarageTheme.backgroundRaised)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(GarageTheme.border, lineWidth: 1)
                )
        )
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    BucketStrikeView()
        .preferredColorScheme(.dark)
}
