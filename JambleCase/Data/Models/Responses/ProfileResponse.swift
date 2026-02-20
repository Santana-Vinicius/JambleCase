import Foundation

struct ProfileResponse: Codable {
    let id: String
    let name: String
    let username: String
    let imageUrl: String
    let bio: String
    let joinedDate: String
    let stats: ProfileStatsResponse
    let badge: BadgeResponse
}

struct ProfileStatsResponse: Codable {
    let shippingDays: Double
    let rating: Double
    let ratingCount: Int
    let followers: Int
    let referrals: Int
}

struct BadgeResponse: Codable {
    let type: String
    let iconName: String
    let color: String
}
