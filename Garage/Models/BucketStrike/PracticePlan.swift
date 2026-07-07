import Foundation

struct PracticePlanDrill: Codable, Hashable, Identifiable {
    var id: String {
        drill.id
    }

    let order: Int
    let drill: Drill
    let isBackfill: Bool
    let estimatedMinutes: Int
    let ballCount: Int

    init(
        order: Int,
        drill: Drill,
        isBackfill: Bool = false,
        estimatedMinutes: Int,
        ballCount: Int
    ) {
        self.order = order
        self.drill = drill
        self.isBackfill = isBackfill
        self.estimatedMinutes = estimatedMinutes
        self.ballCount = ballCount
    }
}

struct PracticePlan: Codable, Hashable {
    let environment: PracticeEnvironment
    let focus: Focus
    let drills: [PracticePlanDrill]

    var minutes: Int {
        drills.reduce(0) { total, planDrill in
            total + planDrill.estimatedMinutes
        }
    }

    var balls: Int {
        drills.reduce(0) { total, planDrill in
            total + planDrill.ballCount
        }
    }
}
