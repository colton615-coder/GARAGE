import SwiftUI

enum GarageTab: String, CaseIterable, Identifiable {
    case home
    case bucketStrike
    case tempo
    case coltsCaddy

    var id: String { rawValue }

    var title: String {
        switch self {
        case .home:
            "Home"
        case .bucketStrike:
            "BucketStrike"
        case .tempo:
            "Tempo"
        case .coltsCaddy:
            "Colt's Caddy"
        }
    }

    var symbolName: String {
        switch self {
        case .home:
            "house.fill"
        case .bucketStrike:
            "basket.fill"
        case .tempo:
            "waveform.path.ecg"
        case .coltsCaddy:
            "figure.golf"
        }
    }
}

struct GarageRootView: View {
    @State private var selectedTab: GarageTab = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(GarageTab.allCases) { tab in
                NavigationStack {
                    tabContent(for: tab)
                }
                .tabItem {
                    Label(tab.title, systemImage: tab.symbolName)
                }
                .tag(tab)
            }
        }
        .tint(GarageTheme.accentBlue)
        .preferredColorScheme(.dark)
        .dynamicTypeSize(.small ... .xxLarge)
    }

    @ViewBuilder
    private func tabContent(for tab: GarageTab) -> some View {
        switch tab {
        case .home:
            GarageHomeView { selectedTab = $0 }
        case .bucketStrike:
            BucketStrikeView()
        case .tempo:
            TempoView()
        case .coltsCaddy:
            ColtsCaddyView()
        }
    }
}

#Preview {
    GarageRootView()
}
