import Foundation
import SwiftUI

final class ProfileService: ProfileServiceProtocol {
    private let repository: ProfileRepositoryProtocol
    
    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }
    
    func loadUserProfile(userId: String) async throws -> ProfileDTO {
        let response = try await repository.getProfile(userId: userId)
        return mapToProfileDTO(response)
    }
    
    func loadReviewsContent(userId: String) async throws -> ReviewsContent {
        let response = try await repository.getReviews(userId: userId)
        
        let reviews = response.reviews
            .map { mapToReviewItemDTO($0) }
            .sorted { $0.rating > $1.rating }
        
        return ReviewsContent(
            reviews: reviews,
            averageRating: response.metadata.averageRating,
            totalReviews: response.metadata.totalCount
        )
    }
    
    func loadLivesContent(userId: String) async throws -> [LiveItemDTO] {
        let responses = try await repository.getLives(userId: userId)
        
        return responses
            .map { mapToLiveItemDTO($0) }
            .sorted { live1, live2 in
                switch (live1.badge, live2.badge) {
                case (.live, .scheduled):
                    return true
                case (.scheduled, .live):
                    return false
                case (.live(let viewers1), .live(let viewers2)):
                    return viewers1 > viewers2
                case (.scheduled, .scheduled):
                    return live1.likes > live2.likes
                }
            }
    }
    
    func loadBookmarksContent(userId: String) async throws -> [BookmarkItemDTO] {
        let responses = try await repository.getBookmarks(userId: userId)
        
        return responses
            .map { mapToBookmarkItemDTO($0) }
            .sorted { b1, b2 in
                switch (b1.badge, b2.badge) {
                case (.live, .scheduled):
                    return true
                case (.scheduled, .live):
                    return false
                case (.live(let viewers1), .live(let viewers2)):
                    return viewers1 > viewers2
                case (.scheduled, .scheduled):
                    return b1.likes > b2.likes
                }
            }
    }
    
    func refreshContent(userId: String, contentType: ProfileContentType) async throws {
        switch contentType {
        case .lives:
            _ = try await loadLivesContent(userId: userId)
        case .reviews:
            _ = try await loadReviewsContent(userId: userId)
        case .bookmarks:
            _ = try await loadBookmarksContent(userId: userId)
        }
    }
    
    // MARK: - Mapping
    
    private func mapToProfileDTO(_ response: ProfileResponse) -> ProfileDTO {
        let userName = InfoLabelDTO(
            iconName: "icon-link",
            text: "@\(response.username)",
            textColor: Color(hex: "#7E53F8") ?? Color.purple
        )
        
        let badge = InfoLabelDTO(
            iconName: response.badge.iconName,
            text: response.badge.type.capitalized,
            textColor: Color(hex: response.badge.color) ?? Color.black
        )
        
        let joinedDate = InfoLabelDTO(
            iconName: "icon-calendar",
            text: "Joined \(DateFormatter.formatJoinedDate(from: response.joinedDate))",
            textColor: Color(hex: "#6C7B93") ?? Color.gray
        )
        
        let pills = [
            StatsPillDTO(iconName: "icon-truck-fast", text: formatShippingDays(response.stats.shippingDays)),
            StatsPillDTO(iconName: "icon-star", text: formatRating(response.stats.rating, count: response.stats.ratingCount)),
            StatsPillDTO(iconName: "icon-people", text: formatCompact(response.stats.followers)),
            StatsPillDTO(iconName: "icon-chart-star", text: "+\(response.stats.referrals)")
        ]
        
        return ProfileDTO(
            name: response.name,
            image: response.imageUrl,
            userName: userName,
            badge: badge,
            joinedDate: joinedDate,
            pills: pills,
            bio: response.bio
        )
    }
    
    private func formatShippingDays(_ days: Double) -> String {
        days.truncatingRemainder(dividingBy: 1) == 0
            ? "\(Int(days)) days"
            : String(format: "%.1f days", days)
    }

    private func formatRating(_ rating: Double, count: Int) -> String {
        let ratingStr = rating.truncatingRemainder(dividingBy: 1) == 0
            ? String(format: "%.0f", rating)
            : String(format: "%.1f", rating)
        return "\(ratingStr) (\(count))"
    }

    private func formatCompact(_ value: Int) -> String {
        if value >= 1_000_000 {
            let millions = Double(value) / 1_000_000
            return millions.truncatingRemainder(dividingBy: 1) == 0
                ? "\(Int(millions))M"
                : String(format: "%.1fM", millions)
        } else if value >= 1_000 {
            let thousands = Double(value) / 1_000
            return thousands.truncatingRemainder(dividingBy: 1) == 0
                ? "\(Int(thousands))K"
                : String(format: "%.1fK", thousands)
        }
        return "\(value)"
    }

    private func mapToReviewItemDTO(_ response: ReviewResponse) -> ReviewItemDTO {
        ReviewItemDTO(
            id: UUID(uuidString: response.id) ?? UUID(),
            avatar: response.avatar,
            username: response.username,
            rating: response.rating,
            text: response.text,
            timeAgo: DateFormatter.timeAgo(from: response.createdAt)
        )
    }
    
    private func mapToLiveItemDTO(_ response: LiveResponse) -> LiveItemDTO {
        let badge: LiveBadgeType
        if response.status.lowercased() == "live" {
            badge = .live(viewers: response.viewerCount)
        } else if let scheduledTime = response.scheduledTime {
            badge = .scheduled(time: DateFormatter.formatScheduledTime(from: scheduledTime))
        } else {
            badge = .scheduled(time: "Soon")
        }
        
        return LiveItemDTO(
            id: UUID(uuidString: response.id) ?? UUID(),
            coverImage: response.coverImage,
            title: response.title,
            badge: badge,
            likes: response.likes
        )
    }
    
    private func mapToBookmarkItemDTO(_ response: BookmarkResponse) -> BookmarkItemDTO {
        let badge: LiveBadgeType
        if response.status.lowercased() == "live" {
            badge = .live(viewers: response.viewerCount)
        } else if let scheduledTime = response.scheduledTime {
            badge = .scheduled(time: DateFormatter.formatScheduledTime(from: scheduledTime))
        } else {
            badge = .scheduled(time: "Soon")
        }
        
        return BookmarkItemDTO(
            id: UUID(uuidString: response.id) ?? UUID(),
            coverImage: response.coverImage,
            title: response.title,
            badge: badge,
            likes: response.likes
        )
    }
}

extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
}
