import Foundation

struct BookmarkResponse: Codable {
    let id: String
    let coverImage: String
    let title: String
    let status: String
    let viewerCount: Int
    let scheduledTime: String?
    let likes: Int
}
