import SwiftUI

enum GarageTheme {
    static let background = Color(red: 0.015, green: 0.026, blue: 0.024)
    static let backgroundRaised = Color(red: 0.08, green: 0.095, blue: 0.09).opacity(0.92)
    static let panelFill = Color(red: 0.10, green: 0.115, blue: 0.11).opacity(0.86)
    static let border = Color.white.opacity(0.10)
    static let divider = Color.white.opacity(0.08)
    static let textSecondary = Color.white.opacity(0.62)
    static let accentBlue = Color(red: 0.18, green: 0.45, blue: 0.96)
    static let accentGreen = Color(red: 0.16, green: 0.74, blue: 0.40)
    static let accentPurple = Color(red: 0.66, green: 0.42, blue: 1.0)
    static let iconFill = Color.white.opacity(0.07)

    static let pagePadding: CGFloat = 20
    static let cardRadius: CGFloat = 22
    static let pageTopPadding: CGFloat = 24
    static let tabBarClearance: CGFloat = 28
    static let caddyInputClearance: CGFloat = tabBarClearance
}
