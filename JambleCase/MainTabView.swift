import SwiftUI

enum AppTab: Int, CaseIterable {
    case live
    case rewards
    case activity
    case profile

    var title: String {
        switch self {
        case .live: "Live"
        case .rewards: "Rewards"
        case .activity: "Activity"
        case .profile: "Profile"
        }
    }

    var icon: String {
        switch self {
        case .live: "icon-play"
        case .rewards: "icon-rewards"
        case .activity: "icon-activity"
        case .profile: ""
        }
    }
}

struct MainTabView: View {
    @State private var selectedTab: AppTab = .profile
    @StateObject private var profileViewModel: ProfileViewModel

    init(profileViewModel: ProfileViewModel) {
        _profileViewModel = StateObject(wrappedValue: profileViewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                ForEach(AppTab.allCases, id: \.self) { tab in
                    tabContent(for: tab)
                        .opacity(selectedTab == tab ? 1 : 0)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            Divider()

            customTabBar
        }
    }

    // MARK: - Tab Content

    @ViewBuilder
    private func tabContent(for tab: AppTab) -> some View {
        switch tab {
        case .live:
            PlaceholderTabView(
                title: "Live",
                icon: "icon-play",
                color: Color(red: 239/255, green: 68/255, blue: 68/255)
            )
        case .rewards:
            PlaceholderTabView(
                title: "Rewards",
                icon: "icon-rewards",
                color: Color(red: 126/255, green: 83/255, blue: 248/255)
            )
        case .activity:
            PlaceholderTabView(
                title: "Activity",
                icon: "icon-activity",
                color: Color(red: 59/255, green: 130/255, blue: 246/255)
            )
        case .profile:
            ProfileView(viewModel: profileViewModel)
        }
    }

    // MARK: - Custom Tab Bar

    private let unselectedColor = Color(red: 145/255, green: 155/255, blue: 170/255)
    private let selectedColor = Color(red: 23/255, green: 34/255, blue: 51/255)

    private var customTabBar: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        selectedTab = tab
                    }
                } label: {
                    VStack(spacing: 4) {
                        tabIcon(for: tab)
                            .frame(width: 28, height: 28)

                        Text(tab.title)
                            .font(.system(
                                size: 10,
                                weight: selectedTab == tab ? .semibold : .medium
                            ))
                            .foregroundStyle(selectedTab == tab ? selectedColor : unselectedColor)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 8)
                    .padding(.bottom, 2)
                }
            }
        }
        .padding(.bottom, 16)
        .background(.white)
    }

    @ViewBuilder
    private func tabIcon(for tab: AppTab) -> some View {
        if tab == .profile {
            if let profile = profileViewModel.profile {
                Image(profile.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 28, height: 28)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(
                                selectedTab == .profile ? selectedColor : Color.clear,
                                lineWidth: 2
                            )
                    )
            } else {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 28, height: 28)
                    .overlay(
                        Circle()
                            .stroke(
                                selectedTab == .profile ? selectedColor : Color.clear,
                                lineWidth: 2
                            )
                    )
            }
        } else {
            Image(tab.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 28, height: 28)
                .foregroundStyle(selectedTab == tab ? selectedColor : unselectedColor)
        }
    }
}
