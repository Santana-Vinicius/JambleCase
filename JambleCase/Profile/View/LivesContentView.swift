import SwiftUI

struct LivesContentView: View {
    @ObservedObject var viewModel: LivesContentViewModel

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        Group {
            if viewModel.isLoading {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(0..<4, id: \.self) { _ in
                        LiveCardSkeletonView()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            } else if viewModel.items.isEmpty {
                EmptyLivesView {
                    print("Schedule a Live tapped")
                }
                .padding(.horizontal, 16)
            } else {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.items) { item in
                        LiveCardView(dto: item)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
        }
        .task {
            viewModel.loadIfNeeded()
        }
    }
}
