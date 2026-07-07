import SwiftUI

struct TempoView: View {
    @State private var bpm = 72.0

    var body: some View {
        GarageScreen {
            VStack(alignment: .leading, spacing: 22) {
                GarageHeader(
                    title: "Tempo",
                    subtitle: "Train rhythm and timing.",
                    trailingSymbol: "gearshape.fill"
                )

                TempoDialView(bpm: bpm)
                    .frame(maxWidth: 306)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 2)

                GarageCard {
                    VStack(spacing: 0) {
                        GarageSettingRow(title: "BPM", value: "\(Int(bpm))", symbolName: "waveform.path.ecg")

                        Divider()
                            .overlay(GarageTheme.divider)

                        GarageSettingRow(title: "Ratio", value: "3.0:1", symbolName: "circlebadge.3", color: GarageTheme.accentGreen)

                        Divider()
                            .overlay(GarageTheme.divider)

                        GarageSettingRow(title: "Audio", value: "Metronome", symbolName: "speaker.wave.2.fill")

                        Divider()
                            .overlay(GarageTheme.divider)

                        GarageSettingRow(title: "Haptics", value: "On", symbolName: "iphone.radiowaves.left.and.right")
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    Slider(value: $bpm, in: 45...120, step: 1)
                        .tint(GarageTheme.accentBlue)
                        .accessibilityLabel("BPM")
                }

                GaragePrimaryButton(title: "Start Session", symbolName: "play.fill", action: {})
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct TempoDialView: View {
    let bpm: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.11), lineWidth: 16)

            Circle()
                .trim(from: 0.08, to: 0.72)
                .stroke(
                    AngularGradient(
                        colors: [GarageTheme.accentGreen, GarageTheme.accentBlue],
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 13, lineCap: .round)
                )
                .rotationEffect(.degrees(138))

            VStack(spacing: 8) {
                Label("BPM", systemImage: "waveform.path.ecg")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(GarageTheme.textSecondary)

                Text("\(Int(bpm))")
                    .font(.system(size: 62, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .contentTransition(.numericText())

                Rectangle()
                    .fill(GarageTheme.divider)
                    .frame(width: 112, height: 1)

                Text("RATIO")
                    .font(.caption.weight(.semibold))
                    .tracking(1.4)
                    .foregroundStyle(GarageTheme.textSecondary)

                Text("3.0:1")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.white)
            }
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(1, contentMode: .fit)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    TempoView()
        .preferredColorScheme(.dark)
}
