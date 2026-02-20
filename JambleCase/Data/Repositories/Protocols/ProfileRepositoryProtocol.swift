import Foundation

protocol ProfileRepositoryProtocol {
    func getProfile(userId: String) async throws -> ProfileResponse
    func getReviews(userId: String) async throws -> ReviewsResponse
    func getLives(userId: String) async throws -> [LiveResponse]
    func getBookmarks(userId: String) async throws -> [BookmarkResponse]
}
