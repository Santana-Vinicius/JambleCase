import SwiftUI

struct StatsPillView: View {
    var dto: StatsPillDTO

    var body: some View {
        HStack {
            Image(dto.iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)
                .clipped()

            Text(dto.text)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 8)
        .overlay {
            RoundedRectangle(cornerRadius: 10000)
                .stroke(
                    Color(red: 233/255, green: 235/255, blue: 239/255),
                    lineWidth: 1
                )
        }
    }
}
