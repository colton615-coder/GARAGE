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
            successActionTitle: "Made Start Line",
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
            successActionTitle: "Center Strike",
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
            successActionTitle: "Clean Sequence",
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
            successActionTitle: "Hit Distance",
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
            successActionTitle: "Up-and-Down",
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
            successActionTitle: "Landed Spot",
            correctionActionTitle: "Correct Landing",
            trackerLabel: "Landing-spot hits",
            completionRecap: "You completed the one-spot club comparison. Keep the landing spot constant and let the rollout teach the club choice.",
            carryForward: "One spot can create several finishes.",
            accessibilityLabel: "Short-game comparison diagram with one landing spot and three club rollout paths."
        ),
        BucketDrillVisualProfile(
            id: "towel-behind-contact",
            displayName: "Towel Behind",
            family: .contactResult,
            environment: .rangeNet,
            currentIDs: ["towel-behind"],
            visualConfig: .strikeSpray,
            setupTitle: "Place the Towel",
            setupInstruction: "Fold a towel and place it one grip-length behind the ball on the target line.",
            secondaryInstruction: "Clip the ball without touching the towel, then move the towel closer only as contact stays clean.",
            focus: "Ball first, turf in front.",
            whyItMatters: "Low-point control is the core ball-striking skill. The towel gives instant feedback without adding a technical swing thought.",
            equipment: "Club, balls, folded towel",
            progression: "7 of 10 clean strikes",
            goal: "Strike the ball without touching the towel",
            executionCommand: "Make the swing, check whether the towel moved, then count only clean ball-first strikes.",
            successActionTitle: "Clean Strike",
            correctionActionTitle: "Correct Contact",
            trackerLabel: "Clean towel strikes",
            completionRecap: "You completed the towel-behind block. Keep judging contact by whether the low point moved in front of the ball.",
            carryForward: "Ball first, turf in front.",
            accessibilityLabel: "Top-down contact diagram with a ball, target line, and feedback zone behind the ball."
        ),
        BucketDrillVisualProfile(
            id: "feet-together-balance",
            displayName: "Feet-Together Balance",
            family: .motionSequence,
            environment: .rangeNet,
            currentIDs: ["feet-together-balance"],
            visualConfig: .feetTogetherBalance,
            setupTitle: "Narrow the Base",
            setupInstruction: "Stand with your feet touching, use a mid-iron, tee the ball low, and swing at 60 to 70 percent effort.",
            secondaryInstruction: "Hold the finish after each shot; if balance breaks, ease the effort until the swing stays centered.",
            focus: "Finish and freeze.",
            whyItMatters: "Removing the base forces rhythm over muscle and exposes rushed tempo without needing a metronome or count.",
            equipment: "Mid-iron, balls, low tees",
            progression: "8 of 10 balanced finishes",
            goal: "Hold the finish without a stumble",
            executionCommand: "Swing with feet together and count only reps that finish balanced without a step.",
            successActionTitle: "Balanced Finish",
            correctionActionTitle: "Correct Balance",
            trackerLabel: "Balanced finishes",
            completionRecap: "You completed the feet-together balance block. Keep the same centered rhythm when your stance returns to normal.",
            carryForward: "Finish and freeze.",
            accessibilityLabel: "Balance drill diagram showing a narrow stance and a held finish checkpoint."
        ),
        BucketDrillVisualProfile(
            id: "driver-gate",
            displayName: "Driver Gate",
            family: .spatialSetup,
            environment: .rangeNet,
            currentIDs: ["driver-gate"],
            // gatePutt art currently renders a putting scene — needs driver-context visual later
            visualConfig: .gatePutt,
            setupTitle: "Build the Driver Gate",
            setupInstruction: "Tee the ball and place an alignment rod three to four inches outside it, parallel to the target line.",
            secondaryInstruction: "Swing without hitting the rod, then confirm the ball starts on your intended line.",
            focus: "Room on the outside.",
            whyItMatters: "A neutral path plus a square face gives the shot a fair test without turning the drill into a swing-fault label.",
            equipment: "Driver, balls, tee, alignment rod",
            progression: "7 of 10 clean starts",
            goal: "Start the driver through the corridor",
            executionCommand: "Hit the driver through the outside gate and count only swings that miss the rod and start on line.",
            successActionTitle: "Clean Start",
            correctionActionTitle: "Correct Start",
            trackerLabel: "Driver gate starts",
            completionRecap: "You completed the driver-gate block. Keep the corridor simple and judge the shot by start line plus a clean gate.",
            carryForward: "Room on the outside.",
            accessibilityLabel: "Driver gate diagram with a teed ball, target line, and outside boundary rod."
        ),
        BucketDrillVisualProfile(
            id: "three-and-switch",
            displayName: "Three-and-Switch",
            family: .compareAdapt,
            environment: .rangeNet,
            currentIDs: ["three-and-switch"],
            visualConfig: .twoClubTempoCompare,
            setupTitle: "Pair the Clubs",
            setupInstruction: "Have a driver and a wedge ready on the range.",
            secondaryInstruction: "Hit three smooth driver swings, then immediately hit three wedge swings at the same tempo.",
            focus: "Same song, different club.",
            whyItMatters: "Alternating clubs exposes when the driver speeds up or the wedge decelerates relative to the same full-swing rhythm.",
            equipment: "Driver, wedge, balls",
            progression: "5 alternating rounds",
            goal: "Keep one rhythm across both clubs",
            executionCommand: "Alternate three driver swings and three wedge swings, counting only rounds where both clubs keep the same rhythm.",
            successActionTitle: "Matched Tempo",
            correctionActionTitle: "Correct Tempo",
            trackerLabel: "Matched-tempo rounds",
            completionRecap: "You completed the three-and-switch block. Keep the rhythm constant even when the club changes.",
            carryForward: "Same song, different club.",
            accessibilityLabel: "Two-club tempo comparison diagram with driver and wedge sharing one rhythm pattern."
        ),
        BucketDrillVisualProfile(
            id: "carry-ladder",
            displayName: "Carry Ladder",
            family: .targetZone,
            environment: .rangeNet,
            currentIDs: ["carry-ladder"],
            visualConfig: .distanceLadder,
            setupTitle: "Build Carry Windows",
            setupInstruction: "Pick three targets, such as 30, 50, and 70 yards, or use three swing-length stations with one wedge.",
            secondaryInstruction: "Hit a cluster to each distance, then randomize the called distance to test recall.",
            focus: "Clock face, not effort.",
            whyItMatters: "Wedge distance control improves when each carry window has a repeatable feel and a randomized transfer check.",
            equipment: "Wedge, balls, three targets",
            progression: "30 / 50 / 70 yard windows",
            goal: "Land shots in each carry zone",
            executionCommand: "Call the carry window, hit the wedge, and count only shots that land in the intended zone.",
            successActionTitle: "Hit Carry",
            correctionActionTitle: "Correct Carry",
            trackerLabel: "Carry-window hits",
            completionRecap: "You completed the carry ladder. Keep matching the swing-length feel to the called carry window.",
            carryForward: "Clock face, not effort.",
            accessibilityLabel: "Range ladder diagram with three carry-distance windows and shot clusters."
        ),
        BucketDrillVisualProfile(
            id: "trajectory-three-ways",
            displayName: "Trajectory Three-Ways",
            family: .compareAdapt,
            environment: .shortGame,
            currentIDs: ["trajectory-three-ways"],
            visualConfig: .landingSpotClubCompare,
            setupTitle: "Set One Wedge Target",
            setupInstruction: "Take one wedge to one distance of about 40 yards from an open lie.",
            secondaryInstruction: "Hit the same target with low, standard, and high flights by varying ball position and face.",
            focus: "Handle forward flies it lower.",
            whyItMatters: "Loft and trajectory control with one club builds real short-game adaptability instead of one stock shot.",
            equipment: "Wedge, balls, open short-game target",
            progression: "Low / standard / high flights",
            goal: "Finish three flights near the target",
            executionCommand: "Call the flight, hit the wedge, and count only shots that show the intended trajectory near the target.",
            successActionTitle: "Matched Flight",
            correctionActionTitle: "Correct Flight",
            trackerLabel: "Trajectory matches",
            completionRecap: "You completed the trajectory block. Keep choosing the flight before changing setup or face.",
            carryForward: "Handle forward flies it lower.",
            accessibilityLabel: "Short-game trajectory diagram with one target and three different wedge flight arcs."
        ),
        BucketDrillVisualProfile(
            id: "landing-spot-towel",
            displayName: "Landing-Spot Towel",
            family: .targetZone,
            environment: .shortGame,
            currentIDs: ["landing-spot-towel"],
            visualConfig: .landingSpotClubCompare,
            setupTitle: "Place the Landing Towel",
            setupInstruction: "Lay a towel as the landing target 3 to 15 feet out from a standard chip lie.",
            secondaryInstruction: "Land the ball on the towel first, then read the rollout and adjust club or landing spot.",
            focus: "Land it on the towel, let it roll.",
            whyItMatters: "Landing-spot control separates the carry you control from the rollout you predict.",
            equipment: "Chipping club, balls, towel",
            progression: "5 of 10 towel landings",
            goal: "Land chips on the towel",
            executionCommand: "Chip to the towel and count only balls that land on the chosen spot.",
            successActionTitle: "Landed Towel",
            correctionActionTitle: "Correct Landing",
            trackerLabel: "Towel landings",
            completionRecap: "You completed the landing-spot towel block. Keep picking the landing spot before judging rollout.",
            carryForward: "Land it on the towel, let it roll.",
            accessibilityLabel: "Chipping diagram with a towel landing rectangle and rollout path to the hole."
        ),
        BucketDrillVisualProfile(
            id: "lead-hand-only",
            displayName: "Lead-Hand Only",
            family: .contactResult,
            environment: .shortGame,
            currentIDs: ["lead-hand-only"],
            visualConfig: .strikeSpray,
            setupTitle: "Lead Hand Only",
            setupInstruction: "Take a short chip with only your lead hand on the club, with the trail hand off or lightly supporting.",
            secondaryInstruction: "Keep the hand ahead of the clubhead through impact, then add the trail hand back while keeping the same feel.",
            focus: "Handle leads the head.",
            whyItMatters: "Lead-hand-only chipping physically blocks the scoop and flip that cause chunked and skulled contact.",
            equipment: "Wedge, balls, short-game lie",
            progression: "8 of 10 clean contacts",
            goal: "Chip cleanly with the handle leading",
            executionCommand: "Chip lead-hand only and count only clean contacts where the handle leads through impact.",
            successActionTitle: "Clean Chip",
            correctionActionTitle: "Correct Contact",
            trackerLabel: "Lead-hand contacts",
            completionRecap: "You completed the lead-hand-only block. Keep the handle leading when both hands return to the club.",
            carryForward: "Handle leads the head.",
            accessibilityLabel: "Chipping contact diagram showing the handle ahead of the clubhead through impact."
        ),
        BucketDrillVisualProfile(
            id: "splash-line",
            displayName: "Splash Line",
            family: .contactResult,
            environment: .shortGame,
            currentIDs: ["splash-line"],
            visualConfig: .bunkerSplash,
            setupTitle: "Draw the Splash Line",
            setupInstruction: "Draw a line in the sand perpendicular to the target, starting without a ball.",
            secondaryInstruction: "Enter on the line with an open face and shallow path, then add a ball once the splash is reliable.",
            focus: "Bounce the sand, don't dig.",
            whyItMatters: "A consistent entry point and shallow splash using the bounce are the foundation of reliable greenside bunker play.",
            equipment: "Sand wedge, bunker, balls",
            progression: "8 of 10 line entries",
            goal: "Enter the sand on the line",
            executionCommand: "Splash the sand on the line and count only shallow entries that use the bounce.",
            successActionTitle: "Line Entry",
            correctionActionTitle: "Correct Entry",
            trackerLabel: "Splash-line entries",
            completionRecap: "You completed the splash-line block. Keep the entry point predictable and the splash shallow.",
            carryForward: "Bounce the sand, don't dig.",
            accessibilityLabel: "Bunker splash diagram with a sand-entry line and shallow splash zone."
        ),
        BucketDrillVisualProfile(
            id: "bunker-ladder",
            displayName: "Bunker Ladder",
            family: .targetZone,
            environment: .shortGame,
            currentIDs: ["bunker-ladder"],
            visualConfig: .distanceLadder,
            setupTitle: "Build Bunker Distance",
            setupInstruction: "Use the same lie with targets set progressively farther onto the green.",
            secondaryInstruction: "Keep entry and splash constant while changing only the follow-through length.",
            focus: "Distance lives in the finish.",
            whyItMatters: "Controlling bunker distance by follow-through length keeps the splash predictable instead of adding speed panic.",
            equipment: "Sand wedge, balls, bunker targets",
            progression: "Short / half / full finishes",
            goal: "Land each ball past the previous one",
            executionCommand: "Use the same splash and count only bunker shots that finish in the intended ladder window.",
            successActionTitle: "Hit Bunker Window",
            correctionActionTitle: "Correct Distance",
            trackerLabel: "Bunker-window hits",
            completionRecap: "You completed the bunker ladder. Keep the splash constant and let the finish length control distance.",
            carryForward: "Distance lives in the finish.",
            accessibilityLabel: "Bunker distance diagram with progressive landing bands and follow-through lengths."
        ),
        BucketDrillVisualProfile(
            id: "clock-circle",
            displayName: "Clock Circle",
            family: .scoringProgression,
            environment: .putting,
            currentIDs: ["clock-circle"],
            visualConfig: .puttingClock,
            setupTitle: "Build the Clock",
            setupInstruction: "Place balls at the 3, 6, 9, and 12 o'clock positions around the hole, about 3 feet from the cup.",
            secondaryInstruction: "Hole all four in a row; a miss restarts the circle, then extend the distance as you succeed.",
            focus: "Commit to the center.",
            whyItMatters: "Short-putt conversion under a make-in-a-row requirement builds confidence and pressure tolerance.",
            equipment: "Putter, balls, hole",
            progression: "3 ft then 4 ft clock ring",
            goal: "Clear the full circle",
            executionCommand: "Putt around the clock and count only made putts that keep the circle alive.",
            successActionTitle: "Made Putt",
            correctionActionTitle: "Correct Make",
            trackerLabel: "Clock-circle makes",
            completionRecap: "You completed the clock circle. Keep committing to the center when the short putt matters.",
            carryForward: "Commit to the center.",
            accessibilityLabel: "Putting clock diagram with four balls around a hole at three, six, nine, and twelve o'clock."
        ),
        BucketDrillVisualProfile(
            id: "nine-shot-range",
            displayName: "Nine-Shot Range",
            family: .compareAdapt,
            environment: .rangeNet,
            currentIDs: ["nine-shot-range"],
            visualConfig: .shuffledShotRoutine,
            setupTitle: "Shuffle the Range",
            setupInstruction: "Have your full bag on the range and choose a new club and target on every ball.",
            secondaryInstruction: "Run the full pre-shot routine as if playing 18 holes, never hitting two consecutive shots alike.",
            focus: "New shot, new routine, every time.",
            whyItMatters: "Random practice with a full routine is the best-supported way to move range work toward course transfer.",
            equipment: "Full bag, balls, range targets",
            progression: "Simulated front nine",
            goal: "Play nine unique range shots",
            executionCommand: "Choose a new club and target, run the routine, and count each completed unique shot.",
            successActionTitle: "New Shot",
            correctionActionTitle: "Correct Count",
            trackerLabel: "Shuffled shots",
            completionRecap: "You completed the nine-shot range block. Keep making every range ball a different on-course problem.",
            carryForward: "New shot, new routine, every time.",
            accessibilityLabel: "Range-routine diagram with shuffled club and target prompts for each shot."
        ),
        BucketDrillVisualProfile(
            id: "two-ball-takeaway",
            displayName: "Two-Ball Takeaway",
            family: .motionSequence,
            environment: .rangeNet,
            currentIDs: ["two-ball-takeaway"],
            visualConfig: .twoBallTakeaway,
            setupTitle: "Set the Two Balls",
            setupInstruction: "Place two balls on the target line, one about 3 inches behind the other, and set up to the front ball.",
            secondaryInstruction: "Brush the rear ball away on the backswing, then swing through and strike the front ball cleanly.",
            focus: "Sweep the back ball first.",
            whyItMatters: "Slowing the takeaway smooths path and tempo without turning the drill into a mechanical swing thought.",
            equipment: "Club, balls, range or net station",
            progression: "7 of 10 clean front-ball strikes",
            goal: "Sweep back then strike front",
            executionCommand: "Start the takeaway smoothly enough to brush the rear ball, then count only clean front-ball strikes.",
            successActionTitle: "Clean Takeaway",
            correctionActionTitle: "Correct Sequence",
            trackerLabel: "Two-ball sequences",
            completionRecap: "You completed the two-ball takeaway block. Keep the first move smooth before speed enters the swing.",
            carryForward: "Sweep the back ball first.",
            accessibilityLabel: "Two-ball takeaway diagram showing the rear ball swept before the front ball is struck."
        ),
        BucketDrillVisualProfile(
            id: "circle-your-foot",
            displayName: "Circle-Your-Foot",
            family: .contactResult,
            environment: .shortGame,
            currentIDs: ["circle-your-foot"],
            visualConfig: .bunkerSplash,
            setupTitle: "Draw the Sand Circle",
            setupInstruction: "Draw a foot-sized circle in the sand with the ball in the center.",
            secondaryInstruction: "Enter at the back of the circle, splash the whole circle out, and exit in front.",
            focus: "Throw the whole island out.",
            whyItMatters: "A visible splash circle teaches entry point and splash size without abstract bunker mechanics.",
            equipment: "Sand wedge, bunker, balls",
            progression: "Full-circle splash block",
            goal: "Remove the full circle with the ball",
            executionCommand: "Splash the full circle out of the bunker and count only reps where the whole marked area releases.",
            successActionTitle: "Full Splash",
            correctionActionTitle: "Correct Splash",
            trackerLabel: "Full-circle splashes",
            completionRecap: "You completed the circle-your-foot block. Keep removing the whole splash area instead of digging at the ball.",
            carryForward: "Throw the whole island out.",
            accessibilityLabel: "Bunker diagram with a foot-sized sand circle around the ball being splashed out as one area."
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
        assert(profiles.count == 20, "BucketStrike visual profile proof must contain exactly twenty canonical profiles.")
        assert(Set(profiles.map(\.id)).count == profiles.count, "BucketStrike visual profiles must not duplicate IDs.")
        let mappedCurrentIDs = profiles.flatMap(\.currentIDs)
        let expectedCurrentIDs: Set<String> = [
            "towel-behind",
            "toe-heel-gate",
            "feet-together-balance",
            "driver-gate",
            "three-and-switch",
            "carry-ladder",
            "trajectory-three-ways",
            "landing-spot-towel",
            "roll-out-ratios",
            "lead-hand-only",
            "splash-line",
            "bunker-ladder",
            "start-line-gate",
            "distance-ladder",
            "clock-circle",
            "par-18",
            "nine-shot-range",
            "two-ball-takeaway",
            "continuous-swings",
            "circle-your-foot"
        ]
        assert(Set(mappedCurrentIDs).count == mappedCurrentIDs.count, "BucketStrike visual profile current-ID mappings must not collide.")
        assert(Set(mappedCurrentIDs) == expectedCurrentIDs, "BucketStrike visual profiles must map exactly the canonical drill IDs.")
        assert(profile(for: "start-line-gate")?.id == "start-line-gate-putt", "Putting start-line-gate must resolve to Start-Line Gate Putt.")
        assert(profile(for: "toe-heel-gate")?.id == "center-strike-spray", "toe-heel-gate must resolve to Center-Strike Spray.")
        assert(profile(for: "continuous-swings")?.id == "continuous-step-drill", "continuous-swings must resolve to Continuous Step Drill.")
        assert(profile(for: "distance-ladder")?.id == "distance-ladder", "distance-ladder must resolve to Distance Ladder.")
        assert(profile(for: "par-18")?.id == "up-and-down-challenge", "par-18 must resolve to Up-and-Down Challenge.")
        assert(profile(for: "roll-out-ratios")?.id == "one-landing-spot-many-clubs", "roll-out-ratios must resolve to One-Landing-Spot Many-Clubs.")
        assert(profile(for: "towel-behind")?.id == "towel-behind-contact", "towel-behind must resolve to Towel Behind.")
        assert(profile(for: "feet-together-balance")?.id == "feet-together-balance", "feet-together-balance must resolve to Feet-Together Balance.")
        assert(profile(for: "driver-gate")?.id == "driver-gate", "driver-gate must resolve to Driver Gate.")
        assert(profile(for: "three-and-switch")?.id == "three-and-switch", "three-and-switch must resolve to Three-and-Switch.")
        assert(profile(for: "carry-ladder")?.id == "carry-ladder", "carry-ladder must resolve to Carry Ladder.")
        assert(profile(for: "trajectory-three-ways")?.id == "trajectory-three-ways", "trajectory-three-ways must resolve to Trajectory Three-Ways.")
        assert(profile(for: "landing-spot-towel")?.id == "landing-spot-towel", "landing-spot-towel must resolve to Landing-Spot Towel.")
        assert(profile(for: "lead-hand-only")?.id == "lead-hand-only", "lead-hand-only must resolve to Lead-Hand Only.")
        assert(profile(for: "splash-line")?.id == "splash-line", "splash-line must resolve to Splash Line.")
        assert(profile(for: "bunker-ladder")?.id == "bunker-ladder", "bunker-ladder must resolve to Bunker Ladder.")
        assert(profile(for: "clock-circle")?.id == "clock-circle", "clock-circle must resolve to Clock Circle.")
        assert(profile(for: "nine-shot-range")?.id == "nine-shot-range", "nine-shot-range must resolve to Nine-Shot Range.")
        assert(profile(for: "two-ball-takeaway")?.id == "two-ball-takeaway", "two-ball-takeaway must resolve to Two-Ball Takeaway.")
        assert(profile(for: "circle-your-foot")?.id == "circle-your-foot", "circle-your-foot must resolve to Circle-Your-Foot.")
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
            "Made Start Line"
        case "carry-ladder", "distance-ladder":
            "Hit Distance"
        case "landing-spot-towel", "roll-out-ratios", "par-18":
            "Hit Zone"
        case "clock-circle":
            "Made Putt"
        default:
            "Clean Rep"
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
