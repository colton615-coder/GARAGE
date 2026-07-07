import Testing
@testable import Garage

struct PracticePlanFactoryTests {
    @Test
    func everySelectableEnvironmentFocusCombinationProducesValidNonEmptyPlan() {
        for practiceType in BucketPracticeType.allCases {
            for focus in BucketSessionFocus.focuses(for: practiceType) {
                let plan = PracticePlanFactory.makePlan(
                    environment: practiceType.practiceEnvironment,
                    focus: focus.focus
                )

                #expect(!plan.drills.isEmpty)
                #expect(PracticePlanValidator.validate(plan) == .valid)
            }
        }
    }

    @Test
    func rangePlansDoNotContainPuttingGreenOnlyDrills() {
        let puttingOnlyDrillIDs: Set<String> = [
            "start-line-gate",
            "distance-ladder",
            "clock-circle"
        ]

        for focus in BucketSessionFocus.focuses(for: .range) {
            let plan = PracticePlanFactory.makePlan(
                environment: .range,
                focus: focus.focus
            )
            let drillIDs = Set(plan.drills.map(\.id))

            #expect(drillIDs.isDisjoint(with: puttingOnlyDrillIDs))
        }
    }
}
