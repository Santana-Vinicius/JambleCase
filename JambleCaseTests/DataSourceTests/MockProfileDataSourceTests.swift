import Testing
@testable import JambleCase

@MainActor
struct MockProfileDataSourceTests {
    var sut: MockProfileDataSource

    init() {
        let config = MockDataSourceConfig(
            shouldSimulateDelay: false,
            errorRate: 0.0
        )
        sut = MockProfileDataSource(config: config)
    }

    @Test func fetchProfile_Success() async throws {
        let result = try await sut.fetchProfile(userId: "user_001")

        #expect(result.id == "user_001")
        #expect(result.name == "Felipe Sanchez")
        #expect(result.username == "felipe_shop")
        #expect(result.stats.shippingDays == 5.2)
        #expect(result.stats.rating == 4.8)
        #expect(result.stats.ratingCount == 112)
    }

    @Test func fetchReviews_Success() async throws {
        let result = try await sut.fetchReviews(userId: "user_001")

        #expect(!result.reviews.isEmpty)
        #expect(result.metadata.averageRating == 4.8)
        #expect(result.metadata.totalCount == 1234)
        #expect(result.reviews.first?.username == "Alex Chen")
        #expect(result.reviews.first?.rating == 5)
    }

    @Test func fetchLives_Success() async throws {
        let result = try await sut.fetchLives(userId: "user_001")

        #expect(!result.isEmpty)
        #expect(result.first?.title == "Morning Coffee Chat & Tech News")
        #expect(result.first?.status == "live")
        #expect(result.first?.viewerCount == 1234)
    }

    @Test func fetchBookmarks_Success() async throws {
        let result = try await sut.fetchBookmarks(userId: "user_001")

        #expect(!result.isEmpty)
        #expect(result.first?.title == "Epic Gaming Moments Compilation")
        #expect(result.first?.likes == 1523)
    }

    @Test func errorSimulation() async {
        let config = MockDataSourceConfig(
            shouldSimulateDelay: false,
            errorRate: 1.0,
            errorTypes: [.networkUnavailable]
        )
        var mutableSelf = self
        mutableSelf.sut = MockProfileDataSource(config: config)

        await #expect(throws: DataSourceError.self) {
            try await mutableSelf.sut.fetchProfile(userId: "user_001")
        }
    }
}
