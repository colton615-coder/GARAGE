import SwiftUI

struct BucketSessionCompleteView: View {
    private let carryForwardLimit = 50

    @State private var selectedQuality: Int?
    @State private var carryForwardCue = ""

    let plan: BucketPracticePlan
    let onReturn: () -> Void

    private var trimmedCarryForwardCue: String {
        carryForwardCue.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var canFinishReflection: Bool {
        selectedQuality != nil && !trimmedCarryForwardCue.isEmpty
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(GarageTheme.accentGreen)
                        .accessibilityHidden(true)

                    Text("Session Complete")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(.white)
                        .lineLimit(2)
                        .minimumScaleFactor(0.84)

                    Text("\(plan.drills.count) drills completed. \(plan.minutes) minutes planned.")
                        .font(.body)
                        .foregroundStyle(GarageTheme.textSecondary)
                }

                Divider()
                    .overlay(GarageTheme.divider)

                BucketQualityRatingPicker(selection: $selectedQuality)

                BucketCarryForwardField(
                    text: $carryForwardCue,
                    limit: carryForwardLimit
                )
            }
            .padding(.horizontal, GarageTheme.pagePadding)
            .padding(.top, 18)
            .padding(.bottom, 82)
        }
        .scrollContentBackground(.hidden)
        .scrollDismissesKeyboard(.interactively)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            Button {
                finishReflection()
            } label: {
                Label("Return to BucketStrike", systemImage: "basket.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
            }
            .buttonStyle(.borderedProminent)
            .tint(GarageTheme.accentBlue)
            .controlSize(.large)
            .disabled(!canFinishReflection)
            .padding(.horizontal, GarageTheme.pagePadding)
            .padding(.top, 8)
            .padding(.bottom, 8)
            .background(.ultraThinMaterial)
        }
    }

    private func finishReflection() {
        guard canFinishReflection else { return }
        carryForwardCue = trimmedCarryForwardCue
        onReturn()
    }
}

struct BucketQualityRatingPicker: View {
    @Binding var selection: Int?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            GarageSectionHeader(title: "Quality")
                .foregroundStyle(GarageTheme.accentBlue)

            HStack(spacing: 8) {
                ForEach(1...5, id: \.self) { rating in
                    Button {
                        selection = rating
                    } label: {
                        Text("\(rating)")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(selection == rating ? .white : GarageTheme.textSecondary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 46)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(selection == rating ? GarageTheme.accentBlue : GarageTheme.backgroundRaised)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                                            .stroke(selection == rating ? GarageTheme.accentBlue.opacity(0.95) : GarageTheme.border, lineWidth: 1)
                                    )
                            )
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Quality \(rating) of 5")
                    .accessibilityAddTraits(selection == rating ? [.isSelected] : [])
                }
            }
        }
    }
}

struct BucketCarryForwardField: View {
    @Binding var text: String
    let limit: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 4) {
                GarageSectionHeader(title: "Carry Forward")
                    .foregroundStyle(GarageTheme.accentBlue)

                Text("One cue worth keeping.")
                    .font(.footnote)
                    .foregroundStyle(GarageTheme.textSecondary)
            }

            TextField("Example: Smooth to the top", text: $text)
                .font(.body.weight(.semibold))
                .foregroundStyle(.white)
                .textInputAutocapitalization(.words)
                .submitLabel(.done)
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(GarageTheme.backgroundRaised)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(GarageTheme.border, lineWidth: 1)
                        )
                )
                .onChange(of: text) { _, newValue in
                    if newValue.count > limit {
                        text = String(newValue.prefix(limit))
                    }
                }

            Text("\(text.count)/\(limit)")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(GarageTheme.textSecondary)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}
