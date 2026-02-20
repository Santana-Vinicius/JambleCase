import SwiftUI

struct LiveCardSkeletonView: View {
    private let skeletonBase = Color(red: 228/255, green: 230/255, blue: 235/255)

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            coverPlaceholder
            titlePlaceholder
        }
    }

    private var coverPlaceholder: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(skeletonBase)
            .frame(height: 220)
            .shimmer()
            .overlay(alignment: .topLeading) { badgePlaceholder }
            .overlay(alignment: .topTrailing) { likesPlaceholder }
    }

    private var badgePlaceholder: some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(skeletonBase.opacity(0.6))
            .frame(width: 64, height: 22)
            .padding(8)
    }

    private var likesPlaceholder: some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(skeletonBase.opacity(0.6))
            .frame(width: 44, height: 22)
            .padding(8)
    }

    private var titlePlaceholder: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(skeletonBase)
            .frame(height: 14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .shimmer()
    }
}
