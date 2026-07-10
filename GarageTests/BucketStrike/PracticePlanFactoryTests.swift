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

    @Test
    func bucketStrikeStatePreviewUsesCuratedPlanUntilEdited() {
        var state = BucketStrikeState()
        let initialPlan = state.curatedPlan

        #expect(!state.previewPlan.drills.isEmpty)
        #expect(state.previewPlan.matchesPlanShape(of: initialPlan))

        let editedPlan = initialPlan.replacingDrills(Array(initialPlan.drills.prefix(1)))
        state.applyEditedPlan(editedPlan)

        #expect(state.previewPlan.matchesPlanShape(of: editedPlan))

        state.selectFocus(BucketSessionFocus.focuses(for: .range)[1])

        #expect(state.previewPlan.matchesPlanShape(of: state.curatedPlan))
    }
}

private extension BucketPracticePlan {
    func matchesPlanShape(of otherPlan: BucketPracticePlan) -> Bool {
        minutes == otherPlan.minutes
            && balls == otherPlan.balls
            && drills.map(\.id) == otherPlan.drills.map(\.id)
    }
}
