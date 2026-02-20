import SwiftUI

struct ReviewCardView: View {
    var dto: ReviewItemDTO

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            avatar
            content
        }
        .padding(16)
        .background(Color(red: 243/255, green: 244/255, blue: 246/255))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Avatar

    private var avatar: some View {
        Image(dto.avatar)
            .resizable()
            .scaledToFill()
            .frame(width: 36, height: 36)
            .clipShape(Circle())
    }

    // MARK: - Content

    private var content: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(dto.username)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color(red: 23/255, green: 34/255, blue: 51/255))

                Spacer()

                Text(dto.timeAgo)
                    .font(.system(size: 14))
                    .foregroundStyle(Color(red: 148/255, green: 156/255, blue: 167/255))
            }

            starsRow

            if let text = dto.text {
                Text(text)
                    .font(.system(size: 15))
                    .foregroundStyle(Color(red: 108/255, green: 123/255, blue: 147/255))
                    .padding(.top, 2)
            }
        }
    }

    // MARK: - Stars

    private var starsRow: some View {
        HStack(spacing: 4) {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: index <= dto.rating ? "star.fill" : "star")
                    .font(.system(size: 14))
                    .foregroundStyle(
                        index <= dto.rating
                            ? Color(red: 250/255, green: 190/255, blue: 50/255)
                            : Color(red: 200/255, green: 205/255, blue: 215/255)
                    )
            }
        }
    }
}
