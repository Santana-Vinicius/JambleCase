import SwiftUI

struct TabBarView: View {
    @ObservedObject var viewModel: TabBarViewModel
    @Namespace private var namespace

    var body: some View {
        HStack(spacing: 0) {
            ForEach(viewModel.tabItems) { dto in
                TabItem(dto: dto, namespace: namespace) {
                    viewModel.selectTab(dto.id)
                }
            }
        }
    }
}

struct TabItem: View {
    var dto: TabItemDTO
    var namespace: Namespace.ID
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 0) {
                HStack {
                    Image(dto.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    if dto.isSelected {
                        Text(dto.text)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color.black)
                            .transition(
                                .asymmetric(
                                    insertion: .opacity
                                        .combined(with: .scale(scale: 0.85, anchor: .leading)),
                                    removal: .opacity
                                        .combined(with: .scale(scale: 0.85, anchor: .leading))
                                )
                            )
                    }
                }
                .padding(.bottom, 12)

                ZStack(alignment: .bottom) {
                    Divider()
                    if dto.isSelected {
                        Rectangle()
                            .fill(Color.black)
                            .frame(height: 2)
                            .matchedGeometryEffect(id: "indicator", in: namespace)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    TabBarView(
        viewModel: TabBarViewModel(
            tabItems: [
                TabItemDTO(id: .lives, icon: "icon-play", text: "Lives", isSelected: true),
                TabItemDTO(id: .reviews, icon: "icon-star-1", text: "Reviews"),
                TabItemDTO(id: .bookmarks, icon: "icon-heart-dark", text: "Bookmarks")
            ]
        )
    )
}
