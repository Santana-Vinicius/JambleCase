import Foundation

enum MockScenario: String, CaseIterable, Identifiable {
    case scenario1 = "Top Seller"
    case scenario2 = "New Seller"
    case scenario3 = "Empty Lives"

    var id: String { rawValue }

    var filePrefix: String {
        switch self {
        case .scenario1: return ""
        case .scenario2: return "scenario2_"
        case .scenario3: return "scenario3_"
        }
    }
}

struct MockDataSourceConfig {
    var scenario: MockScenario
    var shouldSimulateDelay: Bool
    var delayRange: ClosedRange<TimeInterval>
    var errorRate: Double
    var errorTypes: [DataSourceError]
    
    init(
        scenario: MockScenario = .scenario1,
        shouldSimulateDelay: Bool = true,
        delayRange: ClosedRange<TimeInterval> = 0.5...2.0,
        errorRate: Double = 0.0,
        errorTypes: [DataSourceError] = []
    ) {
        self.scenario = scenario
        self.shouldSimulateDelay = shouldSimulateDelay
        self.delayRange = delayRange
        self.errorRate = min(max(errorRate, 0.0), 1.0)
        self.errorTypes = errorTypes.isEmpty ? [.networkUnavailable] : errorTypes
    }
}
