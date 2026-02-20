import Foundation

struct BookmarkItemDTO: Equatable, Identifiable {
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
