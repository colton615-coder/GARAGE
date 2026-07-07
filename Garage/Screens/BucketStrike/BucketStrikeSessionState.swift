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
    var repCount = 0

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

    mutating func incrementReps() {
        repCount += 1
    }

    mutating func decrementReps() {
        repCount = max(0, repCount - 1)
    }

    mutating func resetReps() {
        repCount = 0
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
        executionStates[currentDrill.id] ?? BucketDrillExecutionState()
    }

    mutating func startCurrentTimer() {
        guard let durationSeconds = currentDrill.executionConfiguration.durationSeconds else { return }
        executionStates[currentDrill.id, default: BucketDrillExecutionState()].startTimer(durationSeconds: durationSeconds)
    }

    mutating func pauseCurrentTimer() {
        executionStates[currentDrill.id, default: BucketDrillExecutionState()].pauseTimer()
    }

    mutating func resetCurrentTimer() {
        executionStates[currentDrill.id, default: BucketDrillExecutionState()].resetTimer()
    }

    mutating func tickCurrentTimer() {
        guard let durationSeconds = currentDrill.executionConfiguration.durationSeconds else { return }
        executionStates[currentDrill.id, default: BucketDrillExecutionState()].tickTimer(durationSeconds: durationSeconds)
    }

    mutating func stopCurrentTimer() {
        executionStates[currentDrill.id, default: BucketDrillExecutionState()].stopTimer()
    }

    mutating func stopAllTimers() {
        for drillID in executionStates.keys {
            executionStates[drillID]?.stopTimer()
        }
    }

    mutating func incrementCurrentReps() {
        executionStates[currentDrill.id, default: BucketDrillExecutionState()].incrementReps()
    }

    mutating func decrementCurrentReps() {
        executionStates[currentDrill.id, default: BucketDrillExecutionState()].decrementReps()
    }

    mutating func resetCurrentReps() {
        executionStates[currentDrill.id, default: BucketDrillExecutionState()].resetReps()
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
}
