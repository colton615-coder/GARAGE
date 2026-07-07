import Testing
@testable import Garage

struct PracticePlanValidatorTests {
    @Test
    func validPlanPasses() {
        let plan = PracticePlan(
            environment: .range,
            focus: .contact,
            drills: [
                planDrill(order: 1, drill: drill(id: "range-contact-1")),
                planDrill(order: 2, drill: drill(id: "range-contact-2"))
            ]
        )

        #expect(PracticePlanValidator.validate(plan) == .valid)
        #expect(plan.minutes == 16)
        #expect(plan.balls == 50)
    }

    @Test
    func rangePlanContainingPuttingGreenOnlyDrillFailsWithEnvironmentMismatch() throws {
        let puttingDrill = drill(
            id: "putting-green-only",
            environments: [.puttingGreen],
            focuses: [.contact]
        )
        let plan = PracticePlan(
            environment: .range,
            focus: .contact,
            drills: [
                planDrill(order: 1, drill: puttingDrill)
            ]
        )

        let violations = try #require(invalidViolations(for: plan))

        #expect(
            violations == [
                .environmentMismatch(
                    drillID: "putting-green-only",
                    planEnvironment: .range,
                    drillEnvironments: [.puttingGreen]
                )
            ]
        )
    }

    @Test
    func emptyPlanFails() throws {
        let plan = PracticePlan(environment: .range, focus: .contact, drills: [])

        let violations = try #require(invalidViolations(for: plan))

        #expect(violations == [.drillCountOutOfRange(actual: 0, allowed: 1...5)])
    }

    @Test
    func overMaxPlanFails() throws {
        let plan = PracticePlan(
            environment: .range,
            focus: .contact,
            drills: (1...6).map { index in
                planDrill(order: index, drill: drill(id: "range-contact-\(index)"))
            }
        )

        let violations = try #require(invalidViolations(for: plan))

        #expect(violations == [.drillCountOutOfRange(actual: 6, allowed: 1...5)])
    }

    @Test
    func duplicateIDPlanFails() throws {
        let duplicate = drill(id: "duplicate-range-contact")
        let plan = PracticePlan(
            environment: .range,
            focus: .contact,
            drills: [
                planDrill(order: 1, drill: duplicate),
                planDrill(order: 2, drill: duplicate)
            ]
        )

        let violations = try #require(invalidViolations(for: plan))

        #expect(violations == [.duplicateDrillIDs(["duplicate-range-contact"])])
    }

    @Test
    func nonContiguousOrderPlanFails() throws {
        let plan = PracticePlan(
            environment: .range,
            focus: .contact,
            drills: [
                planDrill(order: 1, drill: drill(id: "range-contact-1")),
                planDrill(order: 3, drill: drill(id: "range-contact-3"))
            ]
        )

        let violations = try #require(invalidViolations(for: plan))

        #expect(violations == [.nonContiguousOrdering(expected: [1, 2], actual: [1, 3])])
    }

    @Test
    func focusMismatchPlanFails() throws {
        let plan = PracticePlan(
            environment: .range,
            focus: .contact,
            drills: [
                planDrill(
                    order: 1,
                    drill: drill(id: "range-tempo", focuses: [.tempo])
                )
            ]
        )

        let violations = try #require(invalidViolations(for: plan))

        #expect(
            violations == [
                .focusMismatch(
                    drillID: "range-tempo",
                    planFocus: .contact,
                    drillFocuses: [.tempo]
                )
            ]
        )
    }

    @Test
    func explicitBackfillAllowsFocusMismatch() {
        let plan = PracticePlan(
            environment: .range,
            focus: .contact,
            drills: [
                planDrill(
                    order: 1,
                    drill: drill(id: "range-tempo-backfill", focuses: [.tempo]),
                    isBackfill: true
                )
            ]
        )

        #expect(PracticePlanValidator.validate(plan) == .valid)
    }

    private func invalidViolations(for plan: PracticePlan) -> [PracticePlanViolation]? {
        guard case let .invalid(violations) = PracticePlanValidator.validate(plan) else {
            return nil
        }

        return violations
    }

    private func planDrill(
        order: Int,
        drill: Drill,
        isBackfill: Bool = false
    ) -> PracticePlanDrill {
        PracticePlanDrill(
            order: order,
            drill: drill,
            isBackfill: isBackfill,
            estimatedMinutes: 8,
            ballCount: 25
        )
    }

    private func drill(
        id: String,
        environments: [PracticeEnvironment] = [.range],
        focuses: [Focus] = [.contact]
    ) -> Drill {
        Drill(
            id: id,
            name: "Fixture Drill",
            version: 1,
            category: .irons,
            environments: environments,
            focuses: focuses,
            type: .builder,
            purpose: "Fixture purpose.",
            setup: "Fixture setup.",
            steps: ["Fixture step."],
            cue: "Fixture cue.",
            goal: "Fixture goal.",
            visualConcept: "Fixture visual.",
            rationale: "Fixture rationale."
        )
    }
}
