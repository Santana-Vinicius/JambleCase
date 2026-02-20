import Foundation

protocol ProfileServiceProtocol {
    func loadUserProfile(userId: String) async throws -> ProfileDTO
    func loadReviewsContent(userId: String) async throws -> ReviewsContent
    func loadLivesContent(userId: String) async throws -> [LiveItemDTO]
    func loadBookmarksContent(userId: String) async throws -> [BookmarkItemDTO]
    func refreshContent(userId: String, contentType: ProfileContentType) async throws
}

enum ProfileContentType {
    case lives
    case reviews
    case bookmarks
}

struct ReviewsContent {
    let reviews: [ReviewItemDTO]
    let averageRating: Double
    let totalReviews: Int
}
