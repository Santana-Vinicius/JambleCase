import SwiftUI

struct ReviewsContentView: View {
    @ObservedObject var viewModel: ReviewsContentViewModel

    var body: some View {
        VStack(spacing: 0) {
            ratingSummary
            reviewsList
        }
        .padding(.top, 8)
        .task {
            viewModel.loadIfNeeded()
        }
    }

    // MARK: - Rating Summary

    private var ratingSummary: some View {
        HStack(spacing: 0) {
            ratingColumn(
                value: viewModel.formattedRating,
                label: "Out of 5"
            )

            ratingColumn(
                value: viewModel.formattedTotal,
                label: "Reviews"
            )
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
    }

    private func ratingColumn(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(Color(red: 23/255, green: 34/255, blue: 51/255))

            Text(label)
                .font(.system(size: 14))
                .foregroundStyle(Color(red: 108/255, green: 123/255, blue: 147/255))
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Reviews List

    private var reviewsList: some View {
        LazyVStack(spacing: 10) {
            if viewModel.isLoading {
                ForEach(0..<4, id: \.self) { _ in
                    ReviewCardSkeletonView()
                }
            } else {
                ForEach(viewModel.reviews) { review in
                    ReviewCardView(dto: review)
                }
            }
        }
        .padding(.horizontal, 16)
    }
}
