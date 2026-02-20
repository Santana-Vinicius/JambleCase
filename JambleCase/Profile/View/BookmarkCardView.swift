import SwiftUI

struct BookmarkCardView: View {
    var dto: BookmarkItemDTO

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            coverImage
            titleLabel
        }
    }

    // MARK: - Cover

    private var coverImage: some View {
        Image(dto.coverImage)
            .resizable()
            .scaledToFill()
            .frame(height: 220)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(alignment: .topLeading) { badgeView }
            .overlay(alignment: .topTrailing) { likesView }
    }

    // MARK: - Badge

    private var badgeView: some View {
        HStack(spacing: 4) {
            switch dto.badge {
            case .live(let viewers):
                Circle()
                    .fill(Color.white)
                    .frame(width: 6, height: 6)
                Text("Live · \(viewers)")
            case .scheduled(let time):
                Text(time)
            }
        }
        .font(.system(size: 12, weight: .bold))
        .foregroundStyle(.white)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(badgeBackground)
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .padding(8)
    }

    private var badgeBackground: Color {
        switch dto.badge {
        case .live:
            Color(red: 239/255, green: 68/255, blue: 68/255)
        case .scheduled:
            Color.black.opacity(0.6)
        }
    }

    // MARK: - Likes

    private var likesView: some View {
        HStack(spacing: 2) {
            Image("icon-heart-red")
                .resizable()
                .scaledToFit()
                .frame(width: 14, height: 14)
            Text("\(dto.likes)")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 4)
        .background(Color.black.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .padding(8)
    }

    // MARK: - Title

    private var titleLabel: some View {
        Text(dto.title)
            .font(.system(size: 14, weight: .medium))
            .foregroundStyle(.black)
            .lineLimit(1)
            .truncationMode(.tail)
    }
}
