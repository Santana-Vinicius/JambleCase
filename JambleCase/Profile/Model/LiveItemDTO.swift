import Foundation

enum LiveBadgeType: Equatable {
    case live(viewers: Int)
    case scheduled(time: String)
}

struct LiveItemDTO: Equatable, Identifiable {
    let id: UUID
    var coverImage: String
    var title: String
    var badge: LiveBadgeType
    var likes: Int

    init(
        id: UUID = UUID(),
        coverImage: String,
        title: String,
        badge: LiveBadgeType,
        likes: Int
    ) {
        self.id = id
        self.coverImage = coverImage
        self.title = title
        self.badge = badge
        self.likes = likes
    }
}
