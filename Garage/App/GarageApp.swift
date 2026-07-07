import SwiftUI

@main
struct GarageApp: App {
    private let drillLibrary = DrillLibrary()

    var body: some Scene {
        WindowGroup {
            GarageRootView()
        }
    }
}
