import Foundation

protocol ProfileDataSourceProtocol {
    func fetchProfile(userId: String) async throws -> ProfileResponse
    func fetchReviews(userId: String) async throws -> ReviewsResponse
    func fetchLives(userId: String) async throws -> [LiveResponse]
    func fetchBookmarks(userId: String) async throws -> [BookmarkResponse]
}
