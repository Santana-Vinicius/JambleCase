import SwiftUI
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var profile: ProfileDTO?
    @Published var actionButtons: [ActionButtonDTO]
    @Published var isLoadingProfile: Bool = true
    @Published var error: String?
    
    let tabBarViewModel: TabBarViewModel
    let livesViewModel: LivesContentViewModel
    let reviewsViewModel: ReviewsContentViewModel
    let bookmarksViewModel: BookmarksContentViewModel
    let scenarioManager: MockScenarioManager

    private let profileService: ProfileServiceProtocol
    private let userId: String
    private var cancellables = Set<AnyCancellable>()

    var selectedTab: TabIdentifier {
        tabBarViewModel.selectedTab
    }

    init(
        profileService: ProfileServiceProtocol,
        userId: String,
        tabBarViewModel: TabBarViewModel,
        livesViewModel: LivesContentViewModel,
        reviewsViewModel: ReviewsContentViewModel,
        bookmarksViewModel: BookmarksContentViewModel,
        scenarioManager: MockScenarioManager
    ) {
        self.profileService = profileService
        self.userId = userId
        self.tabBarViewModel = tabBarViewModel
        self.livesViewModel = livesViewModel
        self.reviewsViewModel = reviewsViewModel
        self.bookmarksViewModel = bookmarksViewModel
        self.scenarioManager = scenarioManager
        
        self.actionButtons = [
            ActionButtonDTO(
                content: .text("Invite · R$15"),
                style: .filled(Color(hex: "#7E53F8") ?? .purple),
                foregroundColor: .white
            ),
            ActionButtonDTO(
                content: .text("Refer Sellers · R$500"),
                style: .filled(Color(hex: "#0C131D") ?? .black),
                foregroundColor: .white
            ),
            ActionButtonDTO(
                content: .icon("icon-share"),
                style: .filled(Color(hex: "#0C131D") ?? .black),
                foregroundColor: Color(hex: "#0C131D") ?? .black
            )
        ]

        tabBarViewModel.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
        
        Task {
            await loadProfile()
        }
    }

    func didTapEditProfilePhoto() {
    }

    func switchScenario(to scenario: MockScenario) {
        scenarioManager.switchScenario(to: scenario)
        Task {
            await reloadAll()
        }
    }

    func refresh() async {
        switch tabBarViewModel.selectedTab {
        case .lives:
            await livesViewModel.refresh()
        case .reviews:
            await reviewsViewModel.refresh()
        case .bookmarks:
            await bookmarksViewModel.refresh()
        }
    }
    
    private func loadProfile() async {
        isLoadingProfile = true
        error = nil
        
        do {
            profile = try await profileService.loadUserProfile(userId: userId)
            isLoadingProfile = false
        } catch {
            self.error = error.localizedDescription
            isLoadingProfile = false
        }
    }

    private func reloadAll() async {
        await loadProfile()
        await livesViewModel.refresh()
        await reviewsViewModel.refresh()
        await bookmarksViewModel.refresh()
    }
}
