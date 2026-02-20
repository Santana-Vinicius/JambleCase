import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State private var showScenarioPicker = false

    var body: some View {
        VStack(spacing: 16) {
            if viewModel.isLoadingProfile {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = viewModel.error {
                VStack {
                    Text("Error loading profile")
                        .font(.headline)
                    Text(error)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let profile = viewModel.profile {
                headerSection(profile: profile)

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        profileInfoSection(profile: profile)
                        statsPillsSection(profile: profile)
                        bioSection(profile: profile)
                        actionButtonsSection
                        TabBarView(viewModel: viewModel.tabBarViewModel)
                        tabContentSection
                            .contentShape(Rectangle())
                            .gesture(swipeGesture)
                    }
                }
                .refreshable {
                    await viewModel.refresh()
                }
            }
        }
    }

    // MARK: - Sections

    private func headerSection(profile: ProfileDTO) -> some View {
        HStack {
            Text(profile.name)
                .font(.system(size: 26, weight: .bold))

            Spacer()

            Image("icon-plus")
                .frame(width: 44, height: 44)

            Button {
                showScenarioPicker = true
            } label: {
                Image("icon-gear")
                    .frame(width: 44, height: 44)
            }
                .confirmationDialog(
                    "Switch Mock Scenario",
                    isPresented: $showScenarioPicker,
                    titleVisibility: .visible
                ) {
                    ForEach(MockScenario.allCases) { scenario in
                        Button(scenario.rawValue) {
                            viewModel.switchScenario(to: scenario)
                        }
                    }
                } message: {
                    Text("Current: \(viewModel.scenarioManager.currentScenario.rawValue)")
                }
        }
        .padding(.horizontal, 16)
    }

    private func profileInfoSection(profile: ProfileDTO) -> some View {
        HStack {
            profilePhotoView(profile: profile)

            VStack(alignment: .leading) {
                InfoLabelView(dto: profile.userName)
                InfoLabelView(dto: profile.badge)
                InfoLabelView(dto: profile.joinedDate)
            }

            Spacer()
        }
        .padding(.horizontal, 16)
    }

    private func profilePhotoView(profile: ProfileDTO) -> some View {
        Button {
            viewModel.didTapEditProfilePhoto()
        } label: {
            Image(profile.image)
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: 83, height: 83)
                .overlay(alignment: .bottomTrailing) {
                    Image(systemName: "pencil")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 28, height: 28)
                        .background(Color(red: 23/255, green: 34/255, blue: 51/255))
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(.white, lineWidth: 2)
                        )
                }
        }
    }

    private func statsPillsSection(profile: ProfileDTO) -> some View {
        HStack {
            ForEach(profile.pills.indices, id: \.self) { index in
                StatsPillView(dto: profile.pills[index])
            }
            Spacer()
        }
        .padding(.top, 16)
        .padding(.horizontal, 16)
    }

    @ViewBuilder
    private func bioSection(profile: ProfileDTO) -> some View {
        if profile.bio.isEmpty {
            Button {
                print("Bio tapped")
            } label: {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            Color(red: 233/255, green: 235/255, blue: 239/255),
                            lineWidth: 1
                        )
                        .frame(height: 48)

                    Text("Add a bio...")
                        .font(.system(size: 14))
                        .foregroundStyle(Color(hex: "#007AFF") ?? .blue)
                        .padding(.leading, 16)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
        } else {
            BioView(text: profile.bio)
                .padding(.horizontal, 16)
                .padding(.top, 12)
        }
    }

    private var actionButtonsSection: some View {
        HStack(spacing: 8) {
            ForEach(viewModel.actionButtons.indices, id: \.self) { index in
                ActionButton(dto: viewModel.actionButtons[index]) {
                    print("Action button \(index) tapped")
                }
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 16)
    }

    @ViewBuilder
    private var tabContentSection: some View {
        switch viewModel.selectedTab {
        case .lives:
            LivesContentView(viewModel: viewModel.livesViewModel)
        case .reviews:
            ReviewsContentView(viewModel: viewModel.reviewsViewModel)
        case .bookmarks:
            BookmarksContentView(viewModel: viewModel.bookmarksViewModel)
        }
    }

    private var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 30, coordinateSpace: .local)
            .onEnded { value in
                let horizontal = value.translation.width
                let vertical = value.translation.height
                guard abs(horizontal) > abs(vertical) else { return }
                if horizontal < 0 {
                    viewModel.tabBarViewModel.selectNext()
                } else {
                    viewModel.tabBarViewModel.selectPrevious()
                }
            }
    }
}

#Preview {
    ProfileView(
        viewModel: AppDependencies.shared.makeProfileViewModel()
    )
}
