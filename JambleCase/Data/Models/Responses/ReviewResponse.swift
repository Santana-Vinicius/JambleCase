import Foundation

struct ReviewsResponse: Codable {
    let reviews: [ReviewResponse]
    let metadata: ReviewMetadataResponse
}

struct ReviewResponse: Codable {
    let id: String
    let userId: String
    let avatar: String
    let username: String
    let rating: Int
    let text: String?
    let createdAt: String
}

struct ReviewMetadataResponse: Codable {
    let averageRating: Double
    let totalCount: Int
}
