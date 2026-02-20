import Testing
@testable import JambleCase

@MainActor
struct MockScenarioManagerTests {
    var dataSource: MockProfileDataSource
    var sut: MockScenarioManager

    init() {
        let config = MockDataSourceConfig(
            shouldSimulateDelay: false,
            errorRate: 0.0
        )
        dataSource = MockProfileDataSource(config: config)
        sut = MockScenarioManager(dataSource: dataSource)
    }

    @Test func initialScenario_isScenario1() {
        #expect(sut.currentScenario == .scenario1)
        #expect(dataSource.config.scenario == .scenario1)
    }

    @Test func switchScenario_updatesCurrentScenario() {
        sut.switchScenario(to: .scenario2)

        #expect(sut.currentScenario == .scenario2)
    }

    @Test func switchScenario_updatesDataSourceConfig() {
        sut.switchScenario(to: .scenario2)

        #expect(dataSource.config.scenario == .scenario2)
        #expect(dataSource.config.scenario.filePrefix == "scenario2_")
    }

    @Test func switchScenario_toSameScenario_isNoOp() {
        sut.switchScenario(to: .scenario1)

        #expect(sut.currentScenario == .scenario1)
        #expect(dataSource.config.scenario == .scenario1)
    }

    @Test func switchScenario_backAndForth() {
        sut.switchScenario(to: .scenario2)
        #expect(sut.currentScenario == .scenario2)

        sut.switchScenario(to: .scenario1)
        #expect(sut.currentScenario == .scenario1)
        #expect(dataSource.config.scenario.filePrefix == "")
    }

    @Test func fetchProfile_afterSwitchToScenario2_loadsScenario2Data() async throws {
        sut.switchScenario(to: .scenario2)

        let profile = try await dataSource.fetchProfile(userId: "user_002")

        #expect(profile.id == "user_002")
        #expect(profile.name == "Lena Moreira")
        #expect(profile.username == "lena_vintage")
        #expect(profile.stats.rating == 3.2)
        #expect(profile.stats.followers == 45)
    }

    @Test func fetchReviews_afterSwitchToScenario2_loadsScenario2Data() async throws {
        sut.switchScenario(to: .scenario2)

        let reviews = try await dataSource.fetchReviews(userId: "user_002")

        #expect(reviews.reviews.count == 3)
        #expect(reviews.metadata.averageRating == 3.2)
        #expect(reviews.metadata.totalCount == 5)
    }

    @Test func fetchLives_afterSwitchToScenario2_loadsScenario2Data() async throws {
        sut.switchScenario(to: .scenario2)

        let lives = try await dataSource.fetchLives(userId: "user_002")

        #expect(lives.count == 2)
        #expect(lives.allSatisfy { $0.status == "scheduled" })
    }

    @Test func fetchBookmarks_afterSwitchToScenario2_loadsScenario2Data() async throws {
        sut.switchScenario(to: .scenario2)

        let bookmarks = try await dataSource.fetchBookmarks(userId: "user_002")

        #expect(bookmarks.count == 1)
        #expect(bookmarks.first?.title == "How to Start Selling Online")
    }
}
