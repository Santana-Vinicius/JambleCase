import SwiftUI

struct PlaceholderTabView: View {
    let title: String
    let icon: String
    let color: Color

    var body: some View {
        ZStack {
            color.ignoresSafeArea()

            VStack(spacing: 16) {
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48)
                    .foregroundStyle(.white.opacity(0.9))

                Text(title)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(.white)
            }
        }
    }
}
