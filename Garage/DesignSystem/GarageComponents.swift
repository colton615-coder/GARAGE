import SwiftUI

struct GarageScreen<Content: View>: View {
    let content: Content
    let bottomPadding: CGFloat

    init(
        bottomPadding: CGFloat = GarageTheme.tabBarClearance,
        @ViewBuilder content: () -> Content
    ) {
        self.bottomPadding = bottomPadding
        self.content = content()
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            content
                .padding(.horizontal, GarageTheme.pagePadding)
                .padding(.top, GarageTheme.pageTopPadding)
                .padding(.bottom, bottomPadding)
        }
        .scrollContentBackground(.hidden)
        .background(GarageTheme.background.ignoresSafeArea())
    }
}

struct GarageHeader: View {
    let title: String
    let subtitle: String
    var trailingSymbol: String?

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 36, weight: .bold, design: .default))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .minimumScaleFactor(0.86)

                Text(subtitle)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(GarageTheme.textSecondary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.88)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 12)

            if let trailingSymbol {
                GarageIcon(symbolName: trailingSymbol, color: .white.opacity(0.76))
            }
        }
    }
}

struct GarageSectionHeader: View {
    let title: String

    var body: some View {
        Text(title.uppercased())
            .font(.caption.weight(.semibold))
            .tracking(1.8)
            .foregroundStyle(GarageTheme.textSecondary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct GarageCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: GarageTheme.cardRadius, style: .continuous)
                    .fill(GarageTheme.panelFill)
                    .overlay(
                        RoundedRectangle(cornerRadius: GarageTheme.cardRadius, style: .continuous)
                            .stroke(GarageTheme.border, lineWidth: 1)
                    )
            )
    }
}

struct GarageIcon: View {
    let symbolName: String
    var color: Color = GarageTheme.accentBlue

    var body: some View {
        Image(systemName: symbolName)
            .font(.system(size: 22, weight: .semibold))
            .foregroundStyle(color)
            .frame(width: 42, height: 42)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(color.opacity(0.13))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(color.opacity(0.16), lineWidth: 1)
                    )
            )
            .accessibilityHidden(true)
    }
}

struct GaragePrimaryButton: View {
    let title: String
    let symbolName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: symbolName)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
        }
        .buttonStyle(.borderedProminent)
        .tint(GarageTheme.accentBlue)
        .controlSize(.large)
    }
}

struct GarageToolRow: View {
    let title: String
    let subtitle: String
    let symbolName: String
    var color: Color = GarageTheme.accentBlue

    var body: some View {
        HStack(spacing: 13) {
            GarageIcon(symbolName: symbolName, color: color)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)

                Text(subtitle)
                    .font(.footnote)
                    .foregroundStyle(GarageTheme.textSecondary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.92)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 12)

            Image(systemName: "chevron.right")
                .font(.headline.weight(.semibold))
                .foregroundStyle(.white.opacity(0.45))
                .accessibilityHidden(true)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(GarageTheme.backgroundRaised)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(GarageTheme.border, lineWidth: 1)
                )
        )
        .accessibilityElement(children: .combine)
    }
}

struct GarageSettingRow: View {
    let title: String
    let value: String
    let symbolName: String
    var color: Color = GarageTheme.accentBlue

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: symbolName)
                .font(.body.weight(.semibold))
                .foregroundStyle(color)
                .frame(width: 26)
                .accessibilityHidden(true)

            Text(title)
                .font(.body.weight(.semibold))
                .foregroundStyle(.white)

            Spacer()

            Text(value)
                .font(.body.weight(.semibold))
                .foregroundStyle(color)

            Image(systemName: "chevron.right")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white.opacity(0.35))
                .accessibilityHidden(true)
        }
        .padding(.vertical, 13)
    }
}
