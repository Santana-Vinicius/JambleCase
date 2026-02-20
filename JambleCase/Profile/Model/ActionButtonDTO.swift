import SwiftUI

struct ActionButtonDTO: Equatable {
    enum Content: Equatable {
        case text(String)
        case icon(String)
    }

    enum Style: Equatable {
        case filled(Color)
        case outlined(Color)
    }

    var content: Content
    var style: Style
    var foregroundColor: Color
}
