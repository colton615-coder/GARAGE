import Foundation

enum Category: String, Codable, CaseIterable {
    case driver
    case woods
    case irons
    case wedges
    case chipping
    case bunker
    case putting

    var displayName: String {
        switch self {
        case .driver:
            "Driver"
        case .woods:
            "Woods"
        case .irons:
            "Irons"
        case .wedges:
            "Wedges"
        case .chipping:
            "Chipping"
        case .bunker:
            "Bunker"
        case .putting:
            "Putting"
        }
    }
}

enum PracticeEnvironment: String, Codable, CaseIterable {
    case range
    case net
    case shortGame
    case puttingGreen

    var displayName: String {
        switch self {
        case .range:
            "Range"
        case .net:
            "Net"
        case .shortGame:
            "Short Game"
        case .puttingGreen:
            "Putting Green"
        }
    }
}

enum Focus: String, Codable, CaseIterable {
    case contact
    case direction
    case distanceControl
    case tempo
    case trajectory
    case adaptability
    case scoring

    var displayName: String {
        switch self {
        case .contact:
            "Contact"
        case .direction:
            "Direction"
        case .distanceControl:
            "Distance Control"
        case .tempo:
            "Tempo"
        case .trajectory:
            "Trajectory"
        case .adaptability:
            "Adaptability"
        case .scoring:
            "Scoring"
        }
    }
}

enum DrillType: String, Codable, CaseIterable {
    case builder
    case transfer

    var displayName: String {
        switch self {
        case .builder:
            "Builder"
        case .transfer:
            "Transfer"
        }
    }
}

struct Drill: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let version: Int
    let category: Category
    let environments: [PracticeEnvironment]
    let focuses: [Focus]
    let type: DrillType
    let purpose: String
    let setup: String
    let steps: [String]
    let cue: String
    let goal: String
    let visualConcept: String
    let rationale: String
}

struct DrillLibrary {
    let allDrills: [Drill]

    init(bundle: Bundle = .main, resourceName: String = "drills") {
        allDrills = Self.loadDrills(bundle: bundle, resourceName: resourceName)
    }

    func drills(environment: PracticeEnvironment) -> [Drill] {
        allDrills.filter { drill in
            drill.environments.contains(environment)
        }
    }

    func drills(environment: PracticeEnvironment, focus: Focus) -> [Drill] {
        allDrills.filter { drill in
            drill.environments.contains(environment) && drill.focuses.contains(focus)
        }
    }

    private static func loadDrills(bundle: Bundle, resourceName: String) -> [Drill] {
        guard let url = bundle.url(forResource: resourceName, withExtension: "json") else {
            return failLoudly("Missing bundled drill library resource: \(resourceName).json")
        }

        do {
            let data = try Data(contentsOf: url)
            return try decodeDrills(from: data)
        } catch {
            return failLoudly("Unable to load bundled drill library \(resourceName).json: \(error)")
        }
    }

    private static func decodeDrills(from data: Data) throws -> [Drill] {
        do {
            return try JSONDecoder().decode([Drill].self, from: data)
        } catch {
            throw DrillLibraryDecodingError(message: message(for: error))
        }
    }

    private static func message(for error: Error) -> String {
        guard let decodingError = error as? DecodingError else {
            return error.localizedDescription
        }

        switch decodingError {
        case .typeMismatch(_, let context), .valueNotFound(_, let context), .keyNotFound(_, let context), .dataCorrupted(let context):
            let entry = context.codingPath.first { codingKey in
                codingKey.intValue != nil
            }.flatMap { codingKey in
                "entry index \(codingKey.intValue ?? 0)"
            } ?? "drill library"
            let path = context.codingPath.map(\.stringValue).joined(separator: ".")
            let location = path.isEmpty ? entry : "\(entry) at \(path)"
            return "Invalid drill data in \(location): \(context.debugDescription)"
        @unknown default:
            return decodingError.localizedDescription
        }
    }

    private static func failLoudly(_ message: String) -> [Drill] {
        #if DEBUG
        fatalError(message)
        #else
        assertionFailure(message)
        return []
        #endif
    }
}

private struct DrillLibraryDecodingError: LocalizedError {
    let message: String

    var errorDescription: String? {
        message
    }
}
