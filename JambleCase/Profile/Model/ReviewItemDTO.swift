import Foundation

struct ReviewItemDTO: Equatable, Identifiable {
    let id: UUID
    var avatar: String
    var username: String
    var rating: Int
    var text: String?
    var timeAgo: String

    init(
        id: UUID = UUID(),
        avatar: String,
        username: String,
        rating: Int,
        text: String? = nil,
        timeAgo: String
    ) {
        self.id = id
        self.avatar = avatar
        self.username = username
        self.rating = min(max(rating, 0), 5)
        self.text = text
        self.timeAgo = timeAgo
    }
}
