import Foundation
@testable import JambleCase
internal import SwiftUI

final class MockProfileService: ProfileServiceProtocol {
    var shouldThrowError = false
    var errorToThrow: Error = DataLayerError.networkError(underlying: DataSourceError.networkUnavailable)
    
    var mockProfile: ProfileDTO?
    var mockReviewsContent: ReviewsContent?
    var mockLives: [LiveItemDTO] = []
    var mockBookmarks: [BookmarkItemDTO] = []
    
    var loadUserProfileCallCount = 0
    var loadReviewsContentCallCount = 0
    var loadLivesContentCallCount = 0
    var loadBookmarksContentCallCount = 0
    var refreshContentCallCount = 0
    
    func loadUserProfile(userId: String) async throws -> ProfileDTO {
        loadUserProfileCallCount += 1
        
        if shouldThrowError {
            throw errorToThrow
        }
        
        return mockProfile ?? ProfileDTO(
            name: "Test User",
            image: "test-avatar",
            userName: InfoLabelDTO(iconName: "icon-at", text: "@testuser", textColor: .black),
            badge: InfoLabelDTO(iconName: "icon-verified", text: "Verified", textColor: .blue),
            joinedDate: InfoLabelDTO(iconName: "icon-calendar", text: "Joined January 2024", textColor: .gray),
            pills: [],
            bio: "Test bio"
        )
    }
    
    func loadReviewsContent(userId: String) async throws -> ReviewsContent {
        loadReviewsContentCallCount += 1
        
        if shouldThrowError {
            throw errorToThrow
        }
        
        return mockReviewsContent ?? ReviewsContent(
            reviews: [],
            averageRating: 0.0,
            totalReviews: 0
        )
    }
    
    func loadLivesContent(userId: String) async throws -> [LiveItemDTO] {
        loadLivesContentCallCount += 1
        
        if shouldThrowError {
            throw errorToThrow
        }
        
        return mockLives
    }
    
    func loadBookmarksContent(userId: String) async throws -> [BookmarkItemDTO] {
        loadBookmarksContentCallCount += 1
        
        if shouldThrowError {
            throw errorToThrow
        }
        
        return mockBookmarks
    }
    
    func refreshContent(userId: String, contentType: ProfileContentType) async throws {
        refreshContentCallCount += 1
        
        if shouldThrowError {
            throw errorToThrow
        }
    }
}
