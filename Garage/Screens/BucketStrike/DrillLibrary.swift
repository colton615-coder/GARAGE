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

enum DrillExecutionModel: String, Codable, CaseIterable {
    case quantity
    case timer
}

struct Drill: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let version: Int
    let category: Category
    let environments: [PracticeEnvironment]
    let executionModels: [PracticeEnvironment: DrillExecutionModel]?
    let focuses: [Focus]
    let type: DrillType
    let purpose: String
    let setup: String
    let steps: [String]
    let cue: String
    let goal: String
    let visualConcept: String
    let rationale: String
    var featured: Bool = false

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case version
        case category
        case environments
        case executionModels
        case focuses
        case type
        case purpose
        case setup
        case steps
        case cue
        case goal
        case visualConcept
        case rationale
        case featured
    }
}

extension Drill {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        version = try container.decode(Int.self, forKey: .version)
        category = try container.decode(Category.self, forKey: .category)
        environments = try container.decode([PracticeEnvironment].self, forKey: .environments)
        if let rawExecutionModels = try container.decodeIfPresent([String: DrillExecutionModel].self, forKey: .executionModels) {
            var decodedExecutionModels: [PracticeEnvironment: DrillExecutionModel] = [:]

            for (rawEnvironment, executionModel) in rawExecutionModels {
                guard let environment = PracticeEnvironment(rawValue: rawEnvironment) else {
                    throw DecodingError.dataCorruptedError(
                        forKey: .executionModels,
                        in: container,
                        debugDescription: "Invalid executionModels environment key: \(rawEnvironment)"
                    )
                }

                decodedExecutionModels[environment] = executionModel
            }

            executionModels = decodedExecutionModels
        } else {
            executionModels = nil
        }
        focuses = try container.decode([Focus].self, forKey: .focuses)
        type = try container.decode(DrillType.self, forKey: .type)
        purpose = try container.decode(String.self, forKey: .purpose)
        setup = try container.decode(String.self, forKey: .setup)
        steps = try container.decode([String].self, forKey: .steps)
        cue = try container.decode(String.self, forKey: .cue)
        goal = try container.decode(String.self, forKey: .goal)
        visualConcept = try container.decode(String.self, forKey: .visualConcept)
        rationale = try container.decode(String.self, forKey: .rationale)
        featured = try container.decodeIfPresent(Bool.self, forKey: .featured) ?? false
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(version, forKey: .version)
        try container.encode(category, forKey: .category)
        try container.encode(environments, forKey: .environments)
        if let executionModels {
            let rawExecutionModels = Dictionary(uniqueKeysWithValues: executionModels.map { environment, executionModel in
                (environment.rawValue, executionModel)
            })
            try container.encode(rawExecutionModels, forKey: .executionModels)
        }
        try container.encode(focuses, forKey: .focuses)
        try container.encode(type, forKey: .type)
        try container.encode(purpose, forKey: .purpose)
        try container.encode(setup, forKey: .setup)
        try container.encode(steps, forKey: .steps)
        try container.encode(cue, forKey: .cue)
        try container.encode(goal, forKey: .goal)
        try container.encode(visualConcept, forKey: .visualConcept)
        try container.encode(rationale, forKey: .rationale)
        try container.encode(featured, forKey: .featured)
    }
}

struct DrillLibrary {
    let allDrills: [Drill]

    init(bundle: Bundle = .main, resourceName: String = "drills") {
        allDrills = Self.loadDrills(bundle: bundle, resourceName: resourceName)
    }

    /// The drills eligible to be served anywhere in the app. Non-featured drills
    /// stay in `allDrills` but are dormant until their `featured` flag is flipped.
    var featuredDrills: [Drill] {
        allDrills.filter(\.featured)
    }

    func drills(environment: PracticeEnvironment) -> [Drill] {
        featuredDrills.filter { drill in
            drill.environments.contains(environment)
        }
    }

    func drills(environment: PracticeEnvironment, focus: Focus) -> [Drill] {
        featuredDrills.filter { drill in
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
