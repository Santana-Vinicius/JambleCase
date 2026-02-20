import Foundation
@testable import JambleCase

final class MockProfileRepository: ProfileRepositoryProtocol {
    var shouldThrowError = false
    var errorToThrow: Error = DataLayerError.networkError(underlying: DataSourceError.networkUnavailable)
    
    var mockProfile: ProfileResponse?
    var mockReviews: ReviewsResponse?
    var mockLives: [LiveResponse] = []
    var mockBookmarks: [BookmarkResponse] = []
    
    var getProfileCallCount = 0
    var getReviewsCallCount = 0
    var getLivesCallCount = 0
    var getBookmarksCallCount = 0
    
    func getProfile(userId: String) async throws -> ProfileResponse {
        getProfileCallCount += 1
        
        if shouldThrowError {
            throw errorToThrow
        }
        
        return mockProfile ?? ProfileResponse(
            id: userId,
            name: "Test User",
            username: "testuser",
            imageUrl: "test-avatar",
            bio: "Test bio",
            joinedDate: "2024-01-01T00:00:00Z",
            stats: ProfileStatsResponse(shippingDays: 0, rating: 0, ratingCount: 0, followers: 0, referrals: 0),
            badge: BadgeResponse(type: "verified", iconName: "icon-verified", color: "#1DA1F2")
        )
    }
    
    func getReviews(userId: String) async throws -> ReviewsResponse {
        getReviewsCallCount += 1
        
        if shouldThrowError {
            throw errorToThrow
        }
        
        return mockReviews ?? ReviewsResponse(
            reviews: [],
            metadata: ReviewMetadataResponse(averageRating: 0.0, totalCount: 0)
        )
    }
    
    func getLives(userId: String) async throws -> [LiveResponse] {
        getLivesCallCount += 1
        
        if shouldThrowError {
            throw errorToThrow
        }
        
        return mockLives
    }
    
    func getBookmarks(userId: String) async throws -> [BookmarkResponse] {
        getBookmarksCallCount += 1
        
        if shouldThrowError {
            throw errorToThrow
        }
        
        return mockBookmarks
    }
}
