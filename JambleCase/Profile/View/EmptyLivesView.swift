import SwiftUI

struct EmptyLivesView: View {
    var onScheduleTapped: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Spacer()

            Text("There is nothing here yet")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Color(red: 23/255, green: 34/255, blue: 51/255))

            Text("Schedule a show and go Live!")
                .font(.system(size: 14))
                .foregroundStyle(Color(red: 108/255, green: 123/255, blue: 147/255))

            Button(action: onScheduleTapped) {
                Text("Schedule a Live")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 14)
                    .background(Color(red: 126/255, green: 83/255, blue: 248/255))
                    .clipShape(Capsule())
            }
            .padding(.top, 12)

            Spacer()
        }
        .frame(maxWidth: .infinity, minHeight: 300)
    }
}

#Preview {
    EmptyLivesView {
        print("Schedule tapped")
    }
}
