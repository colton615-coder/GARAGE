import SwiftUI

struct GarageHomeView: View {
    var onSelectTool: (GarageTab) -> Void = { _ in }

    var body: some View {
        GarageScreen {
            VStack(alignment: .leading, spacing: 16) {
                GarageHeader(
                    title: "Garage",
                    subtitle: "Practice smarter. Train tempo. Play better.",
                    trailingSymbol: "person.crop.circle"
                )

                VStack(alignment: .leading, spacing: 8) {
                    GarageSectionHeader(title: "Today's Focus")

                    GarageCard {
                        HStack(alignment: .top, spacing: 14) {
                            GarageIcon(symbolName: "scope", color: GarageTheme.accentBlue)

                            VStack(alignment: .leading, spacing: 8) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Tempo Control")
                                        .font(.headline.weight(.bold))
                                        .foregroundStyle(.white)

                                    Text("Smooth is fast. Find your rhythm and commit to it.")
                                        .font(.footnote)
                                        .foregroundStyle(GarageTheme.textSecondary)
                                        .fixedSize(horizontal: false, vertical: true)
                                }

                                Button(action: {}) {
                                    Label("View Plan", systemImage: "checkmark.circle.fill")
                                        .font(.footnote.weight(.semibold))
                                }
                                .buttonStyle(.bordered)
                                .tint(GarageTheme.accentBlue)
                                .controlSize(.regular)
                            }
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    GarageSectionHeader(title: "Training Tools")

                    VStack(spacing: 7) {
                        Button {
                            onSelectTool(.bucketStrike)
                        } label: {
                            GarageToolRow(
                                title: "BucketStrike",
                                subtitle: "Sharpen your accuracy with purposeful ball-striking drills.",
                                symbolName: "basket.fill",
                                color: GarageTheme.accentBlue
                            )
                        }
                        .buttonStyle(.plain)

                        Button {
                            onSelectTool(.tempo)
                        } label: {
                            GarageToolRow(
                                title: "Tempo",
                                subtitle: "Build a consistent swing tempo you can trust under pressure.",
                                symbolName: "waveform.path.ecg",
                                color: GarageTheme.accentGreen
                            )
                        }
                        .buttonStyle(.plain)

                        Button {
                            onSelectTool(.coltsCaddy)
                        } label: {
                            GarageToolRow(
                                title: "Colt's Caddy",
                                subtitle: "Advisory shot help for clearer decisions on the course.",
                                symbolName: "figure.golf",
                                color: Color(red: 0.55, green: 0.38, blue: 1.0)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    GarageSectionHeader(title: "Carry Forward")

                    GarageToolRow(
                        title: "Note from yesterday",
                        subtitle: "Work on transitioning to your lead side earlier in the downswing.",
                        symbolName: "list.clipboard",
                        color: GarageTheme.accentBlue
                    )
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    GarageHomeView()
        .preferredColorScheme(.dark)
}
