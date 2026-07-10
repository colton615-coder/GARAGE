import SwiftUI

struct BucketStrikeState {
    var selectedPracticeType: BucketPracticeType = .range
    var selectedFocus: BucketSessionFocus = BucketSessionFocus.focuses(for: .range)[0]
    private var editedPlan: BucketPracticePlan?

    var availableFocuses: [BucketSessionFocus] {
        BucketSessionFocus.focuses(for: selectedPracticeType)
    }

    var curatedPlan: BucketPracticePlan {
        BucketPracticePlan.makeDisplayPlan(practiceType: selectedPracticeType, focus: selectedFocus)
    }

    var previewPlan: BucketPracticePlan {
        editedPlan ?? curatedPlan
    }

    mutating func selectPracticeType(_ practiceType: BucketPracticeType) {
        selectedPracticeType = practiceType

        let focuses = BucketSessionFocus.focuses(for: practiceType)
        if !focuses.contains(where: { $0.id == selectedFocus.id }) {
            selectedFocus = focuses[0]
        }

        editedPlan = nil
    }

    mutating func selectFocus(_ focus: BucketSessionFocus) {
        selectedFocus = focus
        editedPlan = nil
    }

    mutating func applyEditedPlan(_ plan: BucketPracticePlan) {
        editedPlan = plan
    }

}

enum BucketPracticeType: String, CaseIterable, Identifiable {
    case range
    case net
    case shortGame
    case putting

    var id: String { rawValue }

    var practiceEnvironment: PracticeEnvironment {
        switch self {
        case .range:
            .range
        case .net:
            .net
        case .shortGame:
            .shortGame
        case .putting:
            .puttingGreen
        }
    }

    var title: String {
        switch self {
        case .range:
            "Range"
        case .net:
            "Net"
        case .shortGame:
            "Short Game"
        case .putting:
            "Putting"
        }
    }
}

struct BucketSessionFocus: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let symbolName: String
    let accent: Color
    let focus: Focus

    static func focuses(for practiceType: BucketPracticeType) -> [BucketSessionFocus] {
        switch practiceType {
        case .range:
            [
                BucketSessionFocus(id: "range-direction", title: "Direction", subtitle: "Start it online", symbolName: "target", accent: GarageTheme.accentBlue, focus: .direction),
                BucketSessionFocus(id: "range-contact", title: "Contact", subtitle: "Train solid contact", symbolName: "circle.grid.cross", accent: GarageTheme.accentGreen, focus: .contact),
                BucketSessionFocus(id: "range-tempo", title: "Tempo", subtitle: "Smooth the sequence", symbolName: "metronome", accent: GarageTheme.accentPurple, focus: .tempo)
            ]
        case .net:
            [
                BucketSessionFocus(id: "net-contact", title: "Contact", subtitle: "Center strike reps", symbolName: "circle.grid.cross", accent: GarageTheme.accentGreen, focus: .contact),
                BucketSessionFocus(id: "net-tempo", title: "Tempo", subtitle: "Own the rhythm", symbolName: "metronome", accent: GarageTheme.accentBlue, focus: .tempo),
                BucketSessionFocus(id: "net-scoring", title: "Scoring", subtitle: "Purposeful finish", symbolName: "flag.fill", accent: GarageTheme.accentPurple, focus: .scoring)
            ]
        case .shortGame:
            [
                BucketSessionFocus(id: "short-contact", title: "Contact", subtitle: "Clean strike", symbolName: "circle.grid.cross", accent: GarageTheme.accentGreen, focus: .contact),
                BucketSessionFocus(id: "short-distance", title: "Distance", subtitle: "Control carry", symbolName: "scope", accent: GarageTheme.accentBlue, focus: .distanceControl),
                BucketSessionFocus(id: "short-scoring", title: "Scoring", subtitle: "Finish close", symbolName: "flag.fill", accent: GarageTheme.accentPurple, focus: .scoring)
            ]
        case .putting:
            [
                BucketSessionFocus(id: "putting-direction", title: "Direction", subtitle: "Roll it on line", symbolName: "target", accent: GarageTheme.accentBlue, focus: .direction),
                BucketSessionFocus(id: "putting-distance", title: "Distance", subtitle: "Match pace", symbolName: "gauge.with.dots.needle.50percent", accent: GarageTheme.accentGreen, focus: .distanceControl),
                BucketSessionFocus(id: "putting-scoring", title: "Scoring", subtitle: "Make the short ones", symbolName: "flag.fill", accent: GarageTheme.accentPurple, focus: .scoring)
            ]
        }
    }
}

struct BucketPracticePlan {
    let minutes: Int
    let balls: Int
    let drills: [BucketPlanDrill]

    init(minutes: Int, balls: Int, drills: [BucketPlanDrill]) {
        self.minutes = minutes
        self.balls = balls
        self.drills = drills
    }

    func replacingDrills(_ editedDrills: [BucketPlanDrill]) -> BucketPracticePlan {
        let orderedDrills = editedDrills.enumerated().map { index, drill in
            drill.withOrder(index + 1)
        }

        guard !drills.isEmpty else {
            return BucketPracticePlan(minutes: minutes, balls: balls, drills: orderedDrills)
        }

        let scale = Double(orderedDrills.count) / Double(drills.count)
        let adjustedMinutes = orderedDrills.count == drills.count ? minutes : max(5, Int((Double(minutes) * scale).rounded()))
        let adjustedBalls = orderedDrills.count == drills.count ? balls : max(0, Int((Double(balls) * scale).rounded()))

        return BucketPracticePlan(
            minutes: adjustedMinutes,
            balls: adjustedBalls,
            drills: orderedDrills
        )
    }

    static func makeDisplayPlan(practiceType: BucketPracticeType, focus: BucketSessionFocus) -> BucketPracticePlan {
        let practicePlan = PracticePlanFactory.makePlan(
            environment: practiceType.practiceEnvironment,
            focus: focus.focus
        )

        return BucketPracticePlan(practicePlan: practicePlan, accent: focus.accent)
    }

    init(practicePlan: PracticePlan, accent: Color) {
        minutes = practicePlan.minutes
        balls = practicePlan.balls
        drills = practicePlan.drills.map { planDrill in
            BucketPlanDrill(planDrill: planDrill, accent: accent)
        }
    }
}

struct BucketPlanDrill: Identifiable {
    let id: String
    let order: Int
    let title: String
    let subtitle: String
    let symbolName: String
    let accent: Color
    let setup: String
    let steps: [String]
    let cue: String
    let goal: String

    var executionContent: BucketDrillExecutionContent {
        BucketDrillExecutionContent.content(for: self)
    }

    var executionConfiguration: BucketDrillExecutionConfiguration {
        BucketDrillExecutionConfiguration.configuration(for: self)
    }

    var executionFlowSpec: BucketDrillExecutionFlowSpec? {
        BucketDrillExecutionFlowCatalog.spec(forCurrentDrillID: id)
    }

    init(planDrill: PracticePlanDrill, accent: Color) {
        let drill = planDrill.drill

        id = drill.id
        order = planDrill.order
        title = drill.name
        subtitle = drill.purpose
        symbolName = Self.symbolName(for: drill)
        self.accent = accent
        setup = drill.setup
        steps = drill.steps
        cue = drill.cue
        goal = drill.goal
    }

    init(
        id: String,
        order: Int,
        title: String,
        subtitle: String,
        symbolName: String,
        accent: Color,
        setup: String,
        steps: [String],
        cue: String,
        goal: String
    ) {
        self.id = id
        self.order = order
        self.title = title
        self.subtitle = subtitle
        self.symbolName = symbolName
        self.accent = accent
        self.setup = setup
        self.steps = steps
        self.cue = cue
        self.goal = goal
    }

    func withOrder(_ newOrder: Int) -> BucketPlanDrill {
        BucketPlanDrill(
            id: id,
            order: newOrder,
            title: title,
            subtitle: subtitle,
            symbolName: symbolName,
            accent: accent,
            setup: setup,
            steps: steps,
            cue: cue,
            goal: goal
        )
    }

    private static func symbolName(for drill: Drill) -> String {
        switch drill.type {
        case .builder:
            switch drill.category {
            case .driver, .woods, .irons:
                "target"
            case .wedges, .chipping, .bunker:
                "scope"
            case .putting:
                "smallcircle.filled.circle"
            }
        case .transfer:
            "flag.fill"
        }
    }
}

enum BucketDrillTeachingFamily: String, CaseIterable {
    case spatialSetup
    case contactResult
    case motionSequence
    case targetZone
    case scoringProgression
    case compareAdapt
}

enum BucketDrillEnvironment: String {
    case putting = "Putting"
    case rangeNet = "Range / Net"
    case shortGame = "Short Game"
}

enum BucketDrillVisualConfig: String, Codable {
    case gatePutt
    case strikeSpray
    case stepSequence
    case distanceLadder
    case upDownChallenge
    case landingSpotClubCompare
    case bunkerSplash
    case puttingClock
    case feetTogetherBalance
    case shuffledShotRoutine
    case twoClubTempoCompare
    case twoBallTakeaway
}

struct BucketDrillVisualProfile: Identifiable {
    let id: String
    let displayName: String
    let family: BucketDrillTeachingFamily
    let environment: BucketDrillEnvironment
    let currentIDs: [String]
    let visualConfig: BucketDrillVisualConfig
    let setupTitle: String
    let setupInstruction: String
    let secondaryInstruction: String?
    let focus: String
    let whyItMatters: String?
    let equipment: String
    let progression: String
    let goal: String
    let executionCommand: String
    let successActionTitle: String
    let correctionActionTitle: String
    let trackerLabel: String
    let completionRecap: String
    let carryForward: String
    let accessibilityLabel: String

    var setupCopy: String {
        if let secondaryInstruction {
            return "\(setupInstruction) \(secondaryInstruction)"
        }

        return setupInstruction
    }
}
