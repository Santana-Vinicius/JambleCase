import Foundation

enum TabIdentifier: Hashable {
    case lives
    case reviews
    case bookmarks
}

struct TabItemDTO: Equatable, Identifiable {
    let id: TabIdentifier
    var icon: String
    var text: String
    var isSelected: Bool

    init(
        id: TabIdentifier,
        icon: String,
        text: String,
        isSelected: Bool = false
    ) {
        self.id = id
        self.icon = icon
        self.text = text
        self.isSelected = isSelected
    }
}
