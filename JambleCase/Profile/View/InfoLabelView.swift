import SwiftUI

struct InfoLabelView: View {
    var dto: InfoLabelDTO

    var body: some View {
        HStack {
            Image(dto.iconName)
            Text(dto.text)
                .foregroundStyle(dto.textColor)
        }
    }
}
