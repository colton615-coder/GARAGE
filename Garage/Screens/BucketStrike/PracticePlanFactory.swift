import Foundation

enum PracticePlanFactory {
    static func makePlan(
        environment: PracticeEnvironment,
        focus: Focus,
        drillLibrary: DrillLibrary = DrillLibrary()
    ) -> PracticePlan {
        let focusedDrills = drillLibrary.drills(environment: environment, focus: focus)
        let targetCount = min(3, max(1, focusedDrills.count))
        var selectedDrills = orderedSelection(from: focusedDrills, targetCount: targetCount)
        var backfilledIDs = Set<String>()

        if selectedDrills.count < targetCount {
            let selectedIDs = Set(selectedDrills.map(\.id))
            let backfillCandidates = drillLibrary.drills(environment: environment)
                .filter { !selectedIDs.contains($0.id) }
            let backfills = orderedSelection(
                from: backfillCandidates,
                targetCount: targetCount - selectedDrills.count
            )
            selectedDrills.append(contentsOf: backfills)
            backfilledIDs.formUnion(backfills.map(\.id))
        }

        let planDrills = selectedDrills.enumerated().map { index, drill in
            PracticePlanDrill(
                order: index + 1,
                drill: drill,
                isBackfill: backfilledIDs.contains(drill.id),
                estimatedMinutes: minutesPerDrill(for: selectedDrills.count),
                ballCount: ballsPerDrill(for: selectedDrills.count)
            )
        }
        let plan = PracticePlan(environment: environment, focus: focus, drills: planDrills)

        assert(PracticePlanValidator.validate(plan) == .valid, "PracticePlanFactory produced an invalid plan: \(PracticePlanValidator.validate(plan))")
        return plan
    }

    private static func orderedSelection(from drills: [Drill], targetCount: Int) -> [Drill] {
        guard targetCount > 0 else { return [] }

        let builders = drills
            .filter { $0.type == .builder }
            .sorted { $0.id < $1.id }
        let transfers = drills
            .filter { $0.type == .transfer }
            .sorted { $0.id < $1.id }

        if targetCount == 1 {
            return Array((builders + transfers).prefix(1))
        }

        if let transfer = transfers.first {
            let builderCount = targetCount - 1
            var selection = Array(builders.prefix(builderCount))

            if selection.count < builderCount {
                selection.append(contentsOf: transfers.dropFirst().prefix(builderCount - selection.count))
            }

            if selection.count < targetCount {
                selection.append(transfer)
            }

            return Array(selection.prefix(targetCount))
        }

        return Array(builders.prefix(targetCount))
    }

    private static func minutesPerDrill(for drillCount: Int) -> Int {
        switch drillCount {
        case 1:
            12
        case 2:
            10
        default:
            8
        }
    }

    private static func ballsPerDrill(for drillCount: Int) -> Int {
        switch drillCount {
        case 1:
            20
        case 2:
            18
        default:
            15
        }
    }
}
