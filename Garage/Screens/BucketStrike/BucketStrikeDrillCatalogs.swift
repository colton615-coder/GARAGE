import SwiftUI

enum BucketDrillVisualProfileCatalog {
    static let profiles: [BucketDrillVisualProfile] = [
        BucketDrillVisualProfile(
            id: "start-line-gate-putt",
            displayName: "Start-Line Gate Putt",
            family: .spatialSetup,
            environment: .putting,
            currentIDs: ["start-line-gate"],
            visualConfig: .gatePutt,
            setupTitle: "Build the Putt Gate",
            setupInstruction: "Set two tees just wider than the putter face and roll the ball through the gate on your intended start line.",
            secondaryInstruction: "Count only putts that start through the gate without clipping a tee.",
            focus: "Start the ball on your chosen line.",
            whyItMatters: "A clean start line makes speed and read feedback useful. If the ball cannot start on line, the rest of the putt is hard to judge.",
            equipment: "Putter, ball, two tees",
            progression: "12 clean starts",
            goal: "Roll through the gate on line",
            executionCommand: "Roll the putt through the tee gate and count only made start lines.",
            successActionTitle: "+ Made Start Line",
            correctionActionTitle: "Correct Miss",
            trackerLabel: "Start-line makes",
            completionRecap: "You completed the gate-putt block. Keep judging the rep by whether the ball starts through the gate before caring about make or miss.",
            carryForward: "Build the gate first, then trust the start line.",
            accessibilityLabel: "Top-down putting diagram with a ball, two-tee gate, intended start line, and target lane."
        ),
        BucketDrillVisualProfile(
            id: "center-strike-spray",
            displayName: "Center-Strike Spray",
            family: .contactResult,
            environment: .rangeNet,
            currentIDs: ["toe-heel-gate"],
            visualConfig: .strikeSpray,
            setupTitle: "Map the Strike",
            setupInstruction: "Apply foot spray or face tape to the clubface, choose one club and target, and inspect the face after each swing.",
            secondaryInstruction: "Use the tracker as manual observed strike classification; do not treat it as sensor feedback.",
            focus: "Center the strike before chasing speed.",
            whyItMatters: "The visible strike pattern tells you whether the swing is producing usable contact. Honest contact feedback comes before distance or shape work.",
            equipment: "Club, balls, spray or face tape",
            progression: "Observed strike pattern",
            goal: "Log honest center contact",
            executionCommand: "Swing, inspect the face, then record the strike you can actually observe.",
            successActionTitle: "+ Center Strike",
            correctionActionTitle: "Correct Strike",
            trackerLabel: "Observed center strikes",
            completionRecap: "You completed the strike-spray block. Carry forward the contact pattern you observed on the face.",
            carryForward: "Center contact first; speed comes later.",
            accessibilityLabel: "Top-down strike-spray diagram with a clubface, center strike zone, and observed impact pattern dots."
        ),
        BucketDrillVisualProfile(
            id: "continuous-step-drill",
            displayName: "Continuous Step Drill",
            family: .motionSequence,
            environment: .rangeNet,
            currentIDs: ["continuous-swings"],
            visualConfig: .stepSequence,
            setupTitle: "Rehearse the Step Sequence",
            setupInstruction: "Start balanced, step into the lead side, then swing through without stopping the motion.",
            secondaryInstruction: "Keep the three phases connected instead of turning them into separate poses.",
            focus: "Keep the motion continuous.",
            whyItMatters: "A connected step sequence gives the golfer a physical order: set, step, then swing through. The visual should teach movement, not a static checkpoint.",
            equipment: "Club, ball, net or range space",
            progression: "5-minute movement block",
            goal: "Complete the motion block",
            executionCommand: "Move through set, step, and swing without freezing between phases.",
            successActionTitle: "+ Clean Sequence",
            correctionActionTitle: "Reset Sequence",
            trackerLabel: "Sequence block",
            completionRecap: "You completed the continuous-step block. Keep the same connected order when the swing returns to normal speed.",
            carryForward: "Set, step, swing through.",
            accessibilityLabel: "Three-step movement sequence showing set, step, and swing-through phases connected by arrows."
        ),
        BucketDrillVisualProfile(
            id: "distance-ladder",
            displayName: "Distance Ladder",
            family: .targetZone,
            environment: .putting,
            currentIDs: ["distance-ladder"],
            visualConfig: .distanceLadder,
            setupTitle: "Build Speed Windows",
            setupInstruction: "Roll balls to 5 ft, 10 ft, 20 ft, then 30 ft using the same routine.",
            secondaryInstruction: "Move attention up the ladder only after the pace matches the current zone.",
            focus: "Match pace to the next zone.",
            whyItMatters: "Speed control improves when each distance has a clear finish window instead of a vague target.",
            equipment: "Putter, balls, four distance markers",
            progression: "5 / 10 / 20 / 30 ft zones",
            goal: "Record clean distance hits",
            executionCommand: "Roll each putt to the current distance window before moving up the ladder.",
            successActionTitle: "+ Hit Distance",
            correctionActionTitle: "Correct Distance",
            trackerLabel: "Distance hits",
            completionRecap: "You completed the distance ladder. Keep the same routine as the target window moves farther away.",
            carryForward: "Same routine, new distance.",
            accessibilityLabel: "Top-down putting ladder with distance bands marked five, ten, twenty, and thirty feet."
        ),
        BucketDrillVisualProfile(
            id: "up-and-down-challenge",
            displayName: "Up-and-Down Challenge",
            family: .scoringProgression,
            environment: .shortGame,
            currentIDs: ["par-18"],
            visualConfig: .upDownChallenge,
            setupTitle: "Finish the Hole",
            setupInstruction: "Chip or pitch to a landing spot, putt out, then record the scoring attempt.",
            secondaryInstruction: "Treat each attempt as one complete hole-out sequence, not a pile of loose chips.",
            focus: "Pick the landing spot before choosing speed.",
            whyItMatters: "Short-game scoring is a progression: choose the landing spot, leave a makeable putt, then finish the ball.",
            equipment: "Wedge, putter, balls, landing marker",
            progression: "Chip or pitch, putt out, record",
            goal: "Record completed scoring attempts",
            executionCommand: "Play the ball to the green, putt out, then record the completed attempt.",
            successActionTitle: "+ Up-and-Down",
            correctionActionTitle: "Correct Score",
            trackerLabel: "Scoring attempts",
            completionRecap: "You completed the up-and-down challenge. Keep connecting the short-game shot to the putt that follows.",
            carryForward: "Land it, putt it, record it.",
            accessibilityLabel: "Short-game scoring diagram showing chip or pitch, putt out, and score recording steps."
        ),
        BucketDrillVisualProfile(
            id: "one-landing-spot-many-clubs",
            displayName: "One-Landing-Spot Many-Clubs",
            family: .compareAdapt,
            environment: .shortGame,
            currentIDs: ["roll-out-ratios"],
            visualConfig: .landingSpotClubCompare,
            setupTitle: "Compare Rollout",
            setupInstruction: "Use one landing spot and rotate clubs to see how launch and rollout change.",
            secondaryInstruction: "The landing spot stays fixed; the club choice changes the roll pattern.",
            focus: "Same landing spot, different rollout.",
            whyItMatters: "Club comparison gives the golfer a simple adaptation rule: one spot can produce several finishes depending on launch and rollout.",
            equipment: "Three clubs, balls, landing marker",
            progression: "Club comparison set",
            goal: "Record landed-spot reps",
            executionCommand: "Land each club on the same spot and compare how far it rolls.",
            successActionTitle: "+ Landed Spot",
            correctionActionTitle: "Correct Landing",
            trackerLabel: "Landing-spot hits",
            completionRecap: "You completed the one-spot club comparison. Keep the landing spot constant and let the rollout teach the club choice.",
            carryForward: "One spot can create several finishes.",
            accessibilityLabel: "Short-game comparison diagram with one landing spot and three club rollout paths."
        )
    ]

    private static let profileByCurrentID: [String: BucketDrillVisualProfile] = {
        Dictionary(uniqueKeysWithValues: profiles.flatMap { profile in
            profile.currentIDs.map { ($0, profile) }
        })
    }()

    static func profile(for currentID: String) -> BucketDrillVisualProfile? {
        profileByCurrentID[currentID]
    }

    static func validate() {
        assert(profiles.count == 6, "BucketStrike visual profile proof must contain exactly six canonical profiles.")
        assert(Set(profiles.map(\.id)).count == profiles.count, "BucketStrike visual profiles must not duplicate IDs.")
        let mappedCurrentIDs = profiles.flatMap(\.currentIDs)
        assert(Set(mappedCurrentIDs).count == mappedCurrentIDs.count, "BucketStrike visual profile current-ID mappings must not collide.")
        assert(profile(for: "start-line-gate")?.id == "start-line-gate-putt", "Putting start-line-gate must resolve to Start-Line Gate Putt.")
        assert(profile(for: "toe-heel-gate")?.id == "center-strike-spray", "toe-heel-gate must resolve to Center-Strike Spray.")
        assert(profile(for: "continuous-swings")?.id == "continuous-step-drill", "continuous-swings must resolve to Continuous Step Drill.")
        assert(profile(for: "distance-ladder")?.id == "distance-ladder", "distance-ladder must resolve to Distance Ladder.")
        assert(profile(for: "par-18")?.id == "up-and-down-challenge", "par-18 must resolve to Up-and-Down Challenge.")
        assert(profile(for: "roll-out-ratios")?.id == "one-landing-spot-many-clubs", "roll-out-ratios must resolve to One-Landing-Spot Many-Clubs.")
    }
}

extension BucketPlanDrill {
    var visualProfile: BucketDrillVisualProfile? {
        BucketDrillVisualProfileCatalog.profile(for: id)
    }

    var displayTitle: String {
        visualProfile?.displayName ?? title
    }

    var setupTitle: String {
        if let visualProfile {
            return visualProfile.setupTitle
        }

        return switch id {
        case "driver-gate", "start-line-gate":
            "Build the Gate"
        case "toe-heel-gate", "towel-behind":
            "Find the Window"
        case "clock-circle", "par-18":
            "Commit the Finish"
        case "carry-ladder", "distance-ladder":
            "Distance Ladder"
        default:
            title
        }
    }

    var setupInstructionText: String {
        if let visualProfile {
            return visualProfile.setupCopy
        }

        return executionContent.setup.joined(separator: " ")
    }

    var compactExecutionText: String {
        if let visualProfile {
            return visualProfile.executionCommand
        }

        switch executionConfiguration.mode {
        case .manualReps:
            return "Record only the reps that satisfy the drill task."
        case .timed:
            return "Work the setup calmly until the timer block is complete."
        case .openPractice:
            return "Execute deliberately, then mark the drill complete."
        }
    }

    var focusText: String {
        if let visualProfile {
            return visualProfile.focus
        }

        return executionContent.cues.first ?? executionContent.goal
    }

    var distanceText: String {
        if let visualProfile {
            return visualProfile.progression
        }

        return switch id {
        case "distance-ladder":
            "5 ft, 10 ft, 20 ft, 30 ft"
        case "carry-ladder", "landing-spot-towel", "roll-out-ratios", "par-18":
            "Three landing windows"
        case "driver-gate", "start-line-gate":
            "One narrow start gate"
        case "toe-heel-gate", "towel-behind":
            "One ball position and one strike window"
        default:
            "Player-selected target"
        }
    }

    var goalText: String {
        if let visualProfile {
            return visualProfile.goal
        }

        switch executionConfiguration.mode {
        case .manualReps:
            if let targetReps = executionConfiguration.targetReps {
                return "\(targetReps) clean records"
            }
            return "Clean recorded reps"
        case .timed:
            return "Complete the time block"
        case .openPractice:
            return "One committed drill block"
        }
    }

    var whyItMattersText: String? {
        if let visualProfile {
            return visualProfile.whyItMatters
        }

        return switch id {
        case "driver-gate", "start-line-gate":
            "Start line gives the rest of the shot a fair test. If the ball starts offline, distance and target feedback get noisy."
        case "toe-heel-gate", "towel-behind":
            "A predictable strike window keeps the session honest before you chase speed or shot shape."
        case "carry-ladder", "distance-ladder":
            "Speed control improves when each distance has a clear finish zone."
        default:
            nil
        }
    }

    var startButtonTitle: String {
        switch executionConfiguration.mode {
        case .manualReps:
            "Start Tracking"
        case .timed:
            "Start Timer"
        case .openPractice:
            "Start Drill"
        }
    }

    var successActionTitle: String {
        if let visualProfile {
            return visualProfile.successActionTitle
        }

        return switch id {
        case "driver-gate", "start-line-gate":
            "+ Made Start Line"
        case "carry-ladder", "distance-ladder":
            "+ Hit Distance"
        case "landing-spot-towel", "roll-out-ratios", "par-18":
            "+ Hit Zone"
        case "clock-circle":
            "+ Made Putt"
        default:
            "+ Clean Rep"
        }
    }

    var correctionActionTitle: String {
        if let visualProfile {
            return visualProfile.correctionActionTitle
        }

        return switch executionConfiguration.mode {
        case .manualReps:
            "Correct Count"
        case .timed:
            "Reset"
        case .openPractice:
            "Reset"
        }
    }

    var completionRecapText: String {
        if let visualProfile {
            return visualProfile.completionRecap
        }

        return switch id {
        case "driver-gate", "start-line-gate":
            "You completed the start-line task. Keep the gate simple and judge the ball by whether it starts where intended."
        case "toe-heel-gate", "towel-behind":
            "You completed the strike-window block. Carry forward the contact pattern you could actually observe."
        case "carry-ladder", "distance-ladder":
            "You completed the distance ladder. Keep the same routine as the target moves farther away."
        default:
            "You completed \(title). Keep the same clear task for the next block."
        }
    }

    var carryForwardText: String {
        if let visualProfile {
            return visualProfile.carryForward
        }

        return executionContent.cues.first ?? "Commit to the task before the next ball."
    }
}

enum BucketDrillExecutionFlowStepID: String, CaseIterable {
    case setup
    case cue
    case track
    case reflect
}

struct BucketDrillExecutionFlowStep: Identifiable {
    let id: BucketDrillExecutionFlowStepID
    let label: String
    let screenPurpose: String
    let primaryCTA: String
    let emptyState: String
    let activeState: String
    let completedState: String
    let copyConstraint: String
}

enum BucketDrillTrackerSpec: String {
    case manualStrikePattern = "manual-strike-pattern"
}

struct BucketDrillExecutionFlowSpec {
    let drillID: String
    let title: String
    let trackerType: BucketDrillTrackerSpec
    let measurementBoundary: String
    let steps: [BucketDrillExecutionFlowStep]
}

enum BucketDrillExecutionFlowCatalog {
    static func spec(forCurrentDrillID currentDrillID: String) -> BucketDrillExecutionFlowSpec? {
        guard currentDrillID == centerStrikeSpray.drillID else { return nil }
        return centerStrikeSpray
    }

    static let centerStrikeSpray = BucketDrillExecutionFlowSpec(
        drillID: "toe-heel-gate",
        title: "Center-Strike Spray",
        trackerType: .manualStrikePattern,
        measurementBoundary: "Manual strike-pattern logging only. Do not claim camera, AR, swing-path, speed, launch, or impact readings.",
        steps: [
            BucketDrillExecutionFlowStep(
                id: .setup,
                label: "Setup",
                screenPurpose: "Get the player ready with spray or face tape, one club, one target, and a fixed ball count.",
                primaryCTA: "Start Setup",
                emptyState: "No strike surface prepared yet.",
                activeState: "Apply spray or face tape, choose the club, pick the target, and set the ball count.",
                completedState: "Strike surface, club, target, and ball count are set.",
                copyConstraint: "Keep setup copy physical and equipment-based. Do not mention sensors."
            ),
            BucketDrillExecutionFlowStep(
                id: .cue,
                label: "Cue",
                screenPurpose: "Give the player one simple movement focus before the first ball.",
                primaryCTA: "Use This Cue",
                emptyState: "No swing cue selected yet.",
                activeState: "Center the strike and finish balanced.",
                completedState: "Cue locked for the drill block.",
                copyConstraint: "Use one swing thought only. No dense instruction paragraphs."
            ),
            BucketDrillExecutionFlowStep(
                id: .track,
                label: "Track",
                screenPurpose: "Let the player record honest strike quality from the visible spray or tape pattern.",
                primaryCTA: "Log Strike",
                emptyState: "No strikes logged yet.",
                activeState: "Record each ball as center, heel, toe, high, low, or miss.",
                completedState: "Strike pattern logged for the block.",
                copyConstraint: "Only ask for player-observed contact location. Do not infer club path or speed."
            ),
            BucketDrillExecutionFlowStep(
                id: .reflect,
                label: "Reflect",
                screenPurpose: "Convert the logged pattern into one carry-forward note.",
                primaryCTA: "Save Reflection",
                emptyState: "No carry-forward note yet.",
                activeState: "Answer: What strike pattern showed up?",
                completedState: "Carry-forward note saved for the next session.",
                copyConstraint: "Keep reflection focused on the pattern the player observed."
            )
        ]
    )

}

enum BucketDrillExecutionMode {
    case timed
    case manualReps
    case openPractice
}

struct BucketDrillExecutionConfiguration {
    let mode: BucketDrillExecutionMode
    let durationSeconds: Int?
    let targetReps: Int?

    static func configuration(for drill: BucketPlanDrill) -> BucketDrillExecutionConfiguration {
        switch drill.id {
        case "towel-behind", "toe-heel-gate", "feet-together-balance", "two-ball-takeaway", "continuous-swings", "lead-hand-only", "splash-line", "circle-your-foot":
            BucketDrillExecutionConfiguration(mode: .timed, durationSeconds: 300, targetReps: nil)
        case "driver-gate", "carry-ladder", "trajectory-three-ways", "landing-spot-towel", "roll-out-ratios", "bunker-ladder", "start-line-gate", "distance-ladder", "clock-circle", "par-18", "nine-shot-range", "three-and-switch":
            BucketDrillExecutionConfiguration(mode: .manualReps, durationSeconds: nil, targetReps: targetReps(for: drill.id))
        default:
            BucketDrillExecutionConfiguration(mode: .openPractice, durationSeconds: nil, targetReps: nil)
        }
    }

    private static func targetReps(for drillID: String) -> Int {
        switch drillID {
        case "clock-circle":
            5
        case "driver-gate", "distance-ladder", "carry-ladder":
            10
        case "landing-spot-towel", "roll-out-ratios", "par-18", "start-line-gate", "bunker-ladder":
            12
        default:
            10
        }
    }
}

#if DEBUG
let bucketVisualProfileValidation: Void = BucketDrillVisualProfileCatalog.validate()
#endif

struct BucketDrillExecutionContent {
    let goal: String
    let setup: [String]
    let cues: [String]

    static func content(for drill: BucketPlanDrill) -> BucketDrillExecutionContent {
        BucketDrillExecutionContent(
            goal: drill.goal,
            setup: [drill.setup] + drill.steps,
            cues: [drill.cue]
        )
    }
}
