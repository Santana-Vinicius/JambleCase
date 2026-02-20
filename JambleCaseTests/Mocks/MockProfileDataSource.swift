import Foundation
@testable import JambleCase

final class MockProfileDataSourceForTests: ProfileDataSourceProtocol {
    var shouldThrowError = false
    var errorToThrow: Error = DataSourceError.networkUnavailable
    
    var mockProfile: ProfileResponse?
    var mockReviews: ReviewsResponse?
    var mockLives: [LiveResponse] = []
    var mockBookmarks: [BookmarkResponse] = []
    
    var fetchProfileCallCount = 0
    var fetchReviewsCallCount = 0
    var fetchLivesCallCount = 0
    var fetchBookmarksCallCount = 0
    
    func fetchProfile(userId: String) async throws -> ProfileResponse {
        fetchProfileCallCount += 1
        
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
    
    func fetchReviews(userId: String) async throws -> ReviewsResponse {
        fetchReviewsCallCount += 1
        
        if shouldThrowError {
            throw errorToThrow
        }
        
        return mockReviews ?? ReviewsResponse(
            reviews: [],
            metadata: ReviewMetadataResponse(averageRating: 0.0, totalCount: 0)
        )
    }
    
    func fetchLives(userId: String) async throws -> [LiveResponse] {
        fetchLivesCallCount += 1
        
        if shouldThrowError {
            throw errorToThrow
        }
        
        return mockLives
    }
    
    func fetchBookmarks(userId: String) async throws -> [BookmarkResponse] {
        fetchBookmarksCallCount += 1
        
        if shouldThrowError {
            throw errorToThrow
        }
        
        return mockBookmarks
    }
}
