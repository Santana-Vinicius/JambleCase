import SwiftUI

struct ReviewCardSkeletonView: View {
    private let skeletonBase = Color(red: 228/255, green: 230/255, blue: 235/255)

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            avatarPlaceholder
            contentPlaceholder
        }
        .padding(16)
        .background(Color(red: 243/255, green: 244/255, blue: 246/255))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var avatarPlaceholder: some View {
        Circle()
            .fill(skeletonBase)
            .frame(width: 36, height: 36)
            .shimmer()
    }

    private var contentPlaceholder: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(skeletonBase)
                    .frame(width: 100, height: 14)
                    .shimmer()

                Spacer()

                RoundedRectangle(cornerRadius: 4)
                    .fill(skeletonBase)
                    .frame(width: 30, height: 14)
                    .shimmer()
            }

            RoundedRectangle(cornerRadius: 4)
                .fill(skeletonBase)
                .frame(width: 80, height: 12)
                .shimmer()

            RoundedRectangle(cornerRadius: 4)
                .fill(skeletonBase)
                .frame(height: 12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .shimmer()
        }
    }
}
