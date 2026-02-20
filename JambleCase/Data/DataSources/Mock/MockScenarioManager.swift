import SwiftUI
import Combine

@MainActor
final class MockScenarioManager: ObservableObject {
    @Published private(set) var currentScenario: MockScenario

    private let dataSource: MockProfileDataSource

    init(dataSource: MockProfileDataSource, initialScenario: MockScenario = .scenario1) {
        self.dataSource = dataSource
        self.currentScenario = initialScenario
    }

    func switchScenario(to scenario: MockScenario) {
        guard scenario != currentScenario else { return }
        currentScenario = scenario
        dataSource.config.scenario = scenario
    }
}
