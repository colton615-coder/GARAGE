import SwiftUI

struct ColtsCaddyView: View {
    var body: some View {
        GarageScreen(bottomPadding: GarageTheme.caddyInputClearance) {
            VStack(alignment: .leading, spacing: 22) {
                HStack(spacing: 14) {
                    GarageIcon(symbolName: "figure.golf", color: GarageTheme.accentBlue)

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Colt's Caddy")
                            .font(.title.weight(.bold))
                            .foregroundStyle(.white)
                            .lineLimit(2)
                            .minimumScaleFactor(0.9)

                        Text("Live shot and course help.")
                            .font(.body.weight(.semibold))
                            .foregroundStyle(GarageTheme.textSecondary)
                    }

                    Spacer()

                    GarageIcon(symbolName: "ellipsis", color: .white.opacity(0.72))
                }

                HoleContextCard()

                VStack(spacing: 14) {
                    CaddyMessage(text: "You're 165 out, playing 12 ft uphill with a slight left-to-right breeze.", isUser: false)
                    CaddyMessage(text: "What club do you recommend?", isUser: true)
                    CaddyMessage(text: "I'd go with a 7-iron. That should land soft and hold with the elevation.", isUser: false)
                }

                PromptChipRow()
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            CaddyInputBar()
                .padding(.horizontal, GarageTheme.pagePadding)
                .padding(.top, 10)
                .padding(.bottom, 10)
                .background(.ultraThinMaterial)
        }
        .background(GarageTheme.background.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct HoleContextCard: View {
    var body: some View {
        GarageCard {
            HStack(spacing: 14) {
                GarageIcon(symbolName: "flag.fill", color: GarageTheme.accentGreen)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Hole 7")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.white)

                    Text("Par 4  -  165 yds")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(GarageTheme.textSecondary)

                    Text("To Pin: 165 yds")
                        .font(.subheadline)
                        .foregroundStyle(GarageTheme.accentBlue)
                }

                Spacer()

                VStack(alignment: .leading, spacing: 8) {
                    Label("8 mph SW", systemImage: "wind")
                    Label("+12 ft Elevated", systemImage: "mountain.2")
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)
            }
        }
    }
}

private struct CaddyMessage: View {
    let text: String
    let isUser: Bool

    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            if isUser {
                Spacer(minLength: 36)
            } else {
                GarageIcon(symbolName: "figure.golf", color: GarageTheme.accentBlue)
                    .frame(width: 36, height: 36)
                    .scaleEffect(0.68)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(text)
                    .font(.callout)
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)

                Text("9:41 AM")
                    .font(.caption)
                    .foregroundStyle(GarageTheme.textSecondary)
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(isUser ? GarageTheme.accentBlue.opacity(0.38) : GarageTheme.backgroundRaised)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(isUser ? GarageTheme.accentBlue.opacity(0.45) : GarageTheme.border, lineWidth: 1)
                    )
            )

            if !isUser {
                Spacer(minLength: 36)
            }
        }
    }
}

private struct PromptChipRow: View {
    private let prompts = [
        ("Club Help", "figure.golf"),
        ("Lie", "leaf.fill"),
        ("Wind", "wind"),
        ("Recovery", "flag.fill")
    ]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(prompts, id: \.0) { prompt in
                    Label(prompt.0, systemImage: prompt.1)
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 9)
                        .background(
                            Capsule()
                                .fill(GarageTheme.backgroundRaised)
                                .overlay(Capsule().stroke(GarageTheme.border, lineWidth: 1))
                        )
                }
            }
        }
    }
}

private struct CaddyInputBar: View {
    var body: some View {
        HStack(spacing: 12) {
            Button(action: {}) {
                Image(systemName: "plus")
                    .font(.body.weight(.semibold))
                    .frame(width: 42, height: 42)
            }
            .buttonStyle(.bordered)
            .tint(.white.opacity(0.55))
            .accessibilityLabel("Add context")

            Text("Ask Colt's Caddy...")
                .font(.callout)
                .foregroundStyle(GarageTheme.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 14)
                .frame(height: 44)
                .background(
                    Capsule()
                        .fill(GarageTheme.backgroundRaised)
                        .overlay(Capsule().stroke(GarageTheme.border, lineWidth: 1))
                )

            Button(action: {}) {
                Image(systemName: "arrow.up")
                    .font(.body.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(width: 42, height: 42)
                    .background(Circle().fill(GarageTheme.accentBlue))
            }
            .accessibilityLabel("Send")
        }
    }
}

#Preview {
    ColtsCaddyView()
        .preferredColorScheme(.dark)
}
