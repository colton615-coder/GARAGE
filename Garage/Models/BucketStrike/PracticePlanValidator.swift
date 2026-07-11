import Foundation

enum PracticePlanValidationResult: Equatable {
    case valid
    case invalid([PracticePlanViolation])
}

enum PracticePlanViolation: Equatable {
    case environmentMismatch(
        drillID: String,
        planEnvironment: PracticeEnvironment,
        drillEnvironments: [PracticeEnvironment]
    )
    case focusMismatch(
        drillID: String,
        planFocus: Focus,
        drillFocuses: [Focus]
    )
    case drillCountOutOfRange(actual: Int, allowed: ClosedRange<Int>)
    case duplicateDrillIDs([String])
    case nonContiguousOrdering(expected: [Int], actual: [Int])
    case missingExecutionModel(
        drillID: String,
        environment: PracticeEnvironment,
        expected: DrillExecutionModel
    )
    case executionModelMismatch(
        drillID: String,
        environment: PracticeEnvironment,
        expected: DrillExecutionModel,
        actual: DrillExecutionModel
    )
}

enum PracticePlanValidator {
    private static let allowedDrillCount = 1...5

    static func validate(_ plan: PracticePlan) -> PracticePlanValidationResult {
        var violations: [PracticePlanViolation] = []

        if !allowedDrillCount.contains(plan.drills.count) {
            violations.append(
                .drillCountOutOfRange(
                    actual: plan.drills.count,
                    allowed: allowedDrillCount
                )
            )
        }

        let duplicateIDs = duplicateDrillIDs(in: plan.drills)
        if !duplicateIDs.isEmpty {
            violations.append(.duplicateDrillIDs(duplicateIDs))
        }

        if !plan.drills.isEmpty {
            let actualOrder = plan.drills.map(\.order)
            let expectedOrder = Array(1...plan.drills.count)
            if actualOrder != expectedOrder {
                violations.append(
                    .nonContiguousOrdering(
                        expected: expectedOrder,
                        actual: actualOrder
                    )
                )
            }
        }

        for planDrill in plan.drills {
            let drill = planDrill.drill

            if !drill.environments.contains(plan.environment) {
                violations.append(
                    .environmentMismatch(
                        drillID: drill.id,
                        planEnvironment: plan.environment,
                        drillEnvironments: drill.environments
                    )
                )
            }

            if !planDrill.isBackfill && !drill.focuses.contains(plan.focus) {
                violations.append(
                    .focusMismatch(
                        drillID: drill.id,
                        planFocus: plan.focus,
                        drillFocuses: drill.focuses
                    )
                )
            }

            for environment in drill.environments {
                guard let expectedExecutionModel = requiredExecutionModel(for: environment) else {
                    continue
                }

                guard let actualExecutionModel = drill.executionModels?[environment] else {
                    violations.append(
                        .missingExecutionModel(
                            drillID: drill.id,
                            environment: environment,
                            expected: expectedExecutionModel
                        )
                    )
                    continue
                }

                if actualExecutionModel != expectedExecutionModel {
                    violations.append(
                        .executionModelMismatch(
                            drillID: drill.id,
                            environment: environment,
                            expected: expectedExecutionModel,
                            actual: actualExecutionModel
                        )
                    )
                }
            }
        }

        return violations.isEmpty ? .valid : .invalid(violations)
    }

    private static func requiredExecutionModel(for environment: PracticeEnvironment) -> DrillExecutionModel? {
        switch environment {
        case .range:
            .quantity
        case .net:
            .timer
        case .shortGame, .puttingGreen:
            nil
        }
    }

    private static func duplicateDrillIDs(in drills: [PracticePlanDrill]) -> [String] {
        var seenIDs: Set<String> = []
        var duplicateIDs: Set<String> = []

        for planDrill in drills {
            if !seenIDs.insert(planDrill.id).inserted {
                duplicateIDs.insert(planDrill.id)
            }
        }

        return duplicateIDs.sorted()
    }
}
