import SwiftUI

enum BucketActiveSessionStatus {
    case active
    case completed
}

enum BucketActivePresentationPhase: Equatable {
    case setup
    case active
    case drillComplete
    case nextDrillPreview
}

enum BucketTimedExecutionStatus: Equatable {
    case idle
    case running
    case paused
    case completed
}

struct BucketDrillExecutionState {
    var elapsedSeconds = 0
    var timedStatus: BucketTimedExecutionStatus = .idle
    let target: Int
    private(set) var attempted: Int
    private(set) var succeeded: Int

    init(target: Int = 0, attempted: Int? = nil, succeeded: Int = 0) {
        self.target = max(0, target)
        self.attempted = max(0, attempted ?? target)
        self.succeeded = min(max(0, succeeded), self.attempted)
    }

    mutating func startTimer(durationSeconds: Int) {
        guard elapsedSeconds < durationSeconds else {
            timedStatus = .completed
            return
        }

        timedStatus = .running
    }

    mutating func pauseTimer() {
        guard timedStatus == .running else { return }
        timedStatus = .paused
    }

    mutating func stopTimer() {
        guard timedStatus == .running else { return }
        timedStatus = elapsedSeconds > 0 ? .paused : .idle
    }

    mutating func resetTimer() {
        elapsedSeconds = 0
        timedStatus = .idle
    }

    mutating func tickTimer(durationSeconds: Int) {
        guard timedStatus == .running else { return }

        elapsedSeconds = min(durationSeconds, elapsedSeconds + 1)
        if elapsedSeconds >= durationSeconds {
            timedStatus = .completed
        }
    }

    mutating func captureResult(succeeded: Int, attempted: Int? = nil) {
        let finalAttempted = max(0, attempted ?? target)
        self.attempted = finalAttempted
        self.succeeded = min(max(0, succeeded), finalAttempted)
    }
}

struct BucketActiveSessionState {
    let planSnapshot: BucketPracticePlan
    var currentDrillIndex = 0
    var status: BucketActiveSessionStatus = .active
    var executionStates: [String: BucketDrillExecutionState] = [:]

    var currentDrill: BucketPlanDrill {
        planSnapshot.drills[currentDrillIndex]
    }

    var drillCount: Int {
        planSnapshot.drills.count
    }

    var currentDrillNumber: Int {
        currentDrillIndex + 1
    }

    var progressValue: Double {
        guard drillCount > 0 else { return 0 }
        return Double(currentDrillNumber) / Double(drillCount)
    }

    var canGoPrevious: Bool {
        currentDrillIndex > 0
    }

    var isFinalDrill: Bool {
        currentDrillIndex == drillCount - 1
    }

    var currentExecutionState: BucketDrillExecutionState {
        executionStates[currentDrill.id] ?? makeExecutionState(for: currentDrill)
    }

    mutating func startCurrentTimer() {
        let drill = currentDrill
        guard let durationSeconds = drill.executionConfiguration.durationSeconds else { return }
        let defaultState = makeExecutionState(for: drill)
        executionStates[drill.id, default: defaultState].startTimer(durationSeconds: durationSeconds)
    }

    mutating func pauseCurrentTimer() {
        let drill = currentDrill
        let defaultState = makeExecutionState(for: drill)
        executionStates[drill.id, default: defaultState].pauseTimer()
    }

    mutating func resetCurrentTimer() {
        let drill = currentDrill
        let defaultState = makeExecutionState(for: drill)
        executionStates[drill.id, default: defaultState].resetTimer()
    }

    mutating func tickCurrentTimer() {
        let drill = currentDrill
        guard let durationSeconds = drill.executionConfiguration.durationSeconds else { return }
        let defaultState = makeExecutionState(for: drill)
        executionStates[drill.id, default: defaultState].tickTimer(durationSeconds: durationSeconds)
    }

    mutating func stopCurrentTimer() {
        let drill = currentDrill
        let defaultState = makeExecutionState(for: drill)
        executionStates[drill.id, default: defaultState].stopTimer()
    }

    mutating func stopAllTimers() {
        for drillID in executionStates.keys {
            executionStates[drillID]?.stopTimer()
        }
    }

    mutating func captureCurrentResult(succeeded: Int, attempted: Int? = nil) {
        let drill = currentDrill
        let defaultState = makeExecutionState(for: drill)
        executionStates[drill.id, default: defaultState].captureResult(
            succeeded: succeeded,
            attempted: attempted
        )
    }

    mutating func previousDrill() {
        guard canGoPrevious else { return }
        stopCurrentTimer()
        currentDrillIndex -= 1
    }

    mutating func advance() {
        stopCurrentTimer()
        if isFinalDrill {
            status = .completed
        } else {
            currentDrillIndex += 1
        }
    }

    private func makeExecutionState(for drill: BucketPlanDrill) -> BucketDrillExecutionState {
        BucketDrillExecutionState(target: drill.resultTarget)
    }
}
