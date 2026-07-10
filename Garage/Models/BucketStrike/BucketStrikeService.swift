import Foundation
import Observation

@Observable
final class BucketStrikeService {
    private let drillLibrary: DrillLibrary

    init(drillLibrary: DrillLibrary = DrillLibrary()) {
        self.drillLibrary = drillLibrary
    }

    func generatePlan(environment: PracticeEnvironment, focus: Focus) -> PracticePlan {
        PracticePlanFactory.makePlan(
            environment: environment,
            focus: focus,
            drillLibrary: drillLibrary
        )
    }
}
