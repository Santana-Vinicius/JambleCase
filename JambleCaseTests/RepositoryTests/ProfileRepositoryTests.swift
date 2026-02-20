import Testing
@testable import JambleCase

@MainActor
struct ProfileRepositoryTests {
    var sut: ProfileRepository
    var mockDataSource: MockProfileDataSourceForTests

    init() {
        mockDataSource = MockProfileDataSourceForTests()
        sut = ProfileRepository(dataSource: mockDataSource)
    }

    @Test func getProfile_ReturnsResponseFromDataSource() async throws {
        mockDataSource.mockProfile = ProfileResponse(
            id: "user_001",
            name: "Test User",
            username: "testuser",
            imageUrl: "test-avatar",
            bio: "Test bio",
            joinedDate: "2024-01-01T00:00:00Z",
            stats: ProfileStatsResponse(shippingDays: 3.0, rating: 4.5, ratingCount: 50, followers: 200, referrals: 10),
            badge: BadgeResponse(type: "verified", iconName: "icon-verified", color: "#1DA1F2")
        )

        let result = try await sut.getProfile(userId: "user_001")

        #expect(result.id == "user_001")
        #expect(result.name == "Test User")
        #expect(result.stats.shippingDays == 3.0)
        #expect(mockDataSource.fetchProfileCallCount == 1)
    }

    @Test func getProfile_MapsDataSourceErrorToDataLayerError() async {
        mockDataSource.shouldThrowError = true
        mockDataSource.errorToThrow = DataSourceError.networkUnavailable

        await #expect(throws: DataLayerError.self) {
            try await sut.getProfile(userId: "user_001")
        }
    }

    @Test func getReviews_ReturnsResponseFromDataSource() async throws {
        mockDataSource.mockReviews = ReviewsResponse(
            reviews: [
                ReviewResponse(
                    id: "review_001",
                    userId: "user_001",
                    avatar: "avatar-1",
                    username: "TestUser",
                    rating: 5,
                    text: "Great!",
                    createdAt: "2024-02-15T10:30:00Z"
                )
            ],
            metadata: ReviewMetadataResponse(averageRating: 4.8, totalCount: 100)
        )

        let result = try await sut.getReviews(userId: "user_001")

        #expect(result.reviews.count == 1)
        #expect(result.reviews.first?.username == "TestUser")
        #expect(result.metadata.averageRating == 4.8)
        #expect(result.metadata.totalCount == 100)
        #expect(mockDataSource.fetchReviewsCallCount == 1)
    }

    @Test func getLives_ReturnsResponseFromDataSource() async throws {
        mockDataSource.mockLives = [
            LiveResponse(
                id: "live_001",
                coverImage: "cover-1",
                title: "Test Live",
                status: "live",
                viewerCount: 100,
                scheduledTime: nil,
                likes: 50
            )
        ]

        let result = try await sut.getLives(userId: "user_001")

        #expect(result.count == 1)
        #expect(result.first?.title == "Test Live")
        #expect(result.first?.status == "live")
        #expect(mockDataSource.fetchLivesCallCount == 1)
    }

    @Test func getBookmarks_ReturnsResponseFromDataSource() async throws {
        mockDataSource.mockBookmarks = [
            BookmarkResponse(
                id: "bookmark_001",
                coverImage: "cover-1",
                title: "Test Bookmark",
                status: "scheduled",
                viewerCount: 0,
                scheduledTime: "2024-02-20T18:00:00Z",
                likes: 25
            )
        ]

        let result = try await sut.getBookmarks(userId: "user_001")

        #expect(result.count == 1)
        #expect(result.first?.title == "Test Bookmark")
        #expect(result.first?.status == "scheduled")
        #expect(mockDataSource.fetchBookmarksCallCount == 1)
    }

    @Test func getLives_MapsTimeoutError() async {
        mockDataSource.shouldThrowError = true
        mockDataSource.errorToThrow = DataSourceError.timeout

        await #expect {
            try await sut.getLives(userId: "user_001")
        } throws: { error in
            guard let dataLayerError = error as? DataLayerError,
                  case .timeout = dataLayerError else {
                return false
            }
            return true
        }
    }
}
