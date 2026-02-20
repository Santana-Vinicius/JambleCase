import SwiftUI

struct BookmarksContentView: View {
    @ObservedObject var viewModel: BookmarksContentViewModel

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            if viewModel.isLoading {
                ForEach(0..<4, id: \.self) { _ in
                    LiveCardSkeletonView()
                }
            } else {
                ForEach(viewModel.items) { item in
                    BookmarkCardView(dto: item)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .task {
            viewModel.loadIfNeeded()
        }
    }
}
