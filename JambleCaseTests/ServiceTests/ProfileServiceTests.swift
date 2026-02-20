import Testing
@testable import JambleCase

@MainActor
struct ProfileServiceTests {
    var sut: ProfileService
    var mockRepository: MockProfileRepository

    init() {
        mockRepository = MockProfileRepository()
        sut = ProfileService(repository: mockRepository)
    }

    // MARK: - Profile Mapping

    @Test func loadUserProfile_MapsResponseToDTO() async throws {
        mockRepository.mockProfile = ProfileResponse(
            id: "user_001",
            name: "Sarah Johnson",
            username: "sarahjohnson",
            imageUrl: "profile-avatar",
            bio: "Live streamer",
            joinedDate: "2024-01-01T00:00:00Z",
            stats: ProfileStatsResponse(shippingDays: 5.2, rating: 4.8, ratingCount: 112, followers: 1600, referrals: 99),
            badge: BadgeResponse(type: "verified", iconName: "icon-verified", color: "#1DA1F2")
        )

        let result = try await sut.loadUserProfile(userId: "user_001")

        #expect(result.name == "Sarah Johnson")
        #expect(result.image == "profile-avatar")
        #expect(result.bio == "Live streamer")
        #expect(result.userName.text == "@sarahjohnson")
        #expect(result.badge.text == "Verified")
        #expect(result.pills.count == 4)
        #expect(mockRepository.getProfileCallCount == 1)
    }

    // MARK: - Reviews Mapping + Business Logic

    @Test func loadReviewsContent_MapsAndSortsByRating() async throws {
        mockRepository.mockReviews = ReviewsResponse(
            reviews: [
                ReviewResponse(id: "r1", userId: "u1", avatar: "a1", username: "User1", rating: 3, text: nil, createdAt: "2024-02-15T10:00:00Z"),
                ReviewResponse(id: "r2", userId: "u1", avatar: "a2", username: "User2", rating: 5, text: "Great!", createdAt: "2024-02-14T10:00:00Z"),
                ReviewResponse(id: "r3", userId: "u1", avatar: "a3", username: "User3", rating: 4, text: nil, createdAt: "2024-02-13T10:00:00Z")
            ],
            metadata: ReviewMetadataResponse(averageRating: 4.0, totalCount: 3)
        )

        let result = try await sut.loadReviewsContent(userId: "user_001")

        #expect(result.reviews.count == 3)
        #expect(result.reviews[0].rating == 5)
        #expect(result.reviews[0].username == "User2")
        #expect(result.reviews[1].rating == 4)
        #expect(result.reviews[2].rating == 3)
        #expect(result.averageRating == 4.0)
        #expect(result.totalReviews == 3)
        #expect(mockRepository.getReviewsCallCount == 1)
    }

    // MARK: - Lives Mapping + Business Logic

    @Test func loadLivesContent_MapsAndSortsLiveFirst() async throws {
        mockRepository.mockLives = [
            LiveResponse(id: "l1", coverImage: "c1", title: "Scheduled 1", status: "scheduled", viewerCount: 0, scheduledTime: "2024-02-20T18:00:00Z", likes: 100),
            LiveResponse(id: "l2", coverImage: "c2", title: "Live 1", status: "live", viewerCount: 50, scheduledTime: nil, likes: 200),
            LiveResponse(id: "l3", coverImage: "c3", title: "Live 2", status: "live", viewerCount: 150, scheduledTime: nil, likes: 300)
        ]

        let result = try await sut.loadLivesContent(userId: "user_001")

        #expect(result.count == 3)
        #expect(result[0].title == "Live 2")
        #expect(result[1].title == "Live 1")
        #expect(result[2].title == "Scheduled 1")
        #expect(mockRepository.getLivesCallCount == 1)
    }

    @Test func loadLivesContent_MapsLiveBadgeCorrectly() async throws {
        mockRepository.mockLives = [
            LiveResponse(id: "l1", coverImage: "c1", title: "Live Stream", status: "live", viewerCount: 999, scheduledTime: nil, likes: 50)
        ]

        let result = try await sut.loadLivesContent(userId: "user_001")

        if case .live(let viewers) = result.first?.badge {
            #expect(viewers == 999)
        } else {
            Issue.record("Expected .live badge")
        }
    }

    // MARK: - Bookmarks Mapping + Business Logic

    @Test func loadBookmarksContent_MapsAndSorts() async throws {
        mockRepository.mockBookmarks = [
            BookmarkResponse(id: "b1", coverImage: "c1", title: "Bookmark 1", status: "live", viewerCount: 100, scheduledTime: nil, likes: 50)
        ]

        let result = try await sut.loadBookmarksContent(userId: "user_001")

        #expect(result.count == 1)
        #expect(result.first?.title == "Bookmark 1")
        #expect(mockRepository.getBookmarksCallCount == 1)
    }

    // MARK: - Error Propagation

    @Test func loadUserProfile_PropagatesError() async {
        mockRepository.shouldThrowError = true

        await #expect(throws: DataLayerError.self) {
            try await sut.loadUserProfile(userId: "user_001")
        }
    }
}
