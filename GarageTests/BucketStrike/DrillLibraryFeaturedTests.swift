import Testing
@testable import Garage

struct DrillLibraryFeaturedTests {
    @Test
    func fullLibraryStillContainsAllTwentyDrills() {
        #expect(DrillLibrary().allDrills.count == 20)
    }

    @Test
    func exactlyEightDrillsAreFeatured() {
        #expect(DrillLibrary().featuredDrills.count == 8)
    }

    @Test
    func everyEnvironmentHasAtLeastOneFeaturedDrill() {
        let library = DrillLibrary()

        for environment in PracticeEnvironment.allCases {
            #expect(!library.drills(environment: environment).isEmpty)
        }
    }

    @Test
    func environmentDrillQueriesServeOnlyFeaturedDrills() {
        let library = DrillLibrary()

        for environment in PracticeEnvironment.allCases {
            #expect(library.drills(environment: environment).allSatisfy { $0.featured })

            for focus in Focus.allCases {
                #expect(library.drills(environment: environment, focus: focus).allSatisfy { $0.featured })
            }
        }
    }

    @Test
    func rangeAndNetDrillsDeclareRequiredExecutionModels() {
        let library = DrillLibrary()

        for drill in library.allDrills {
            if drill.environments.contains(.range) {
                #expect(drill.executionModels?[.range] == .quantity)
            }

            if drill.environments.contains(.net) {
                #expect(drill.executionModels?[.net] == .timer)
            }
        }
    }

    @Test
    func shortGameAndPuttingOnlyDrillsLeaveExecutionModelsUnset() {
        let library = DrillLibrary()
        let undecidedEnvironmentDrills = library.allDrills.filter { drill in
            !drill.environments.contains(.range) && !drill.environments.contains(.net)
        }

        #expect(undecidedEnvironmentDrills.allSatisfy { $0.executionModels == nil })
    }

    @Test
    func generatedPlansContainOnlyFeaturedDrills() {
        for practiceType in BucketPracticeType.allCases {
            for focus in BucketSessionFocus.focuses(for: practiceType) {
                let plan = PracticePlanFactory.makePlan(
                    environment: practiceType.practiceEnvironment,
                    focus: focus.focus
                )

                #expect(plan.drills.allSatisfy { $0.drill.featured })
            }
        }
    }
}
