import SwiftUI

struct ProfileDTO: Equatable {
    var name: String
    var image: String
    var userName: InfoLabelDTO
    var badge: InfoLabelDTO
    var joinedDate: InfoLabelDTO
    var pills: [StatsPillDTO]
    var bio: String
}

struct InfoLabelDTO: Equatable {
    var iconName: String
    var text: String
    var textColor: Color
}

struct StatsPillDTO: Equatable {
    var iconName: String
    var text: String
}
