import Foundation

@MainActor
final class AppDependencies {
    static let shared = AppDependencies()
    
    private init() {}

    private lazy var mockProfileDataSource: MockProfileDataSource = {
        let config = MockDataSourceConfig(
            shouldSimulateDelay: true,
            delayRange: 0.5...1.5,
            errorRate: 0.0
        )
        return MockProfileDataSource(config: config)
    }()

    lazy var profileDataSource: ProfileDataSourceProtocol = {
        mockProfileDataSource
    }()
    
    lazy var profileRepository: ProfileRepositoryProtocol = {
        ProfileRepository(dataSource: profileDataSource)
    }()
    
    lazy var profileService: ProfileServiceProtocol = {
        ProfileService(repository: profileRepository)
    }()

    lazy var scenarioManager: MockScenarioManager = {
        MockScenarioManager(dataSource: mockProfileDataSource)
    }()
    
    func makeProfileViewModel() -> ProfileViewModel {
        let userId = "user_001"
        
        let livesViewModel = LivesContentViewModel(
            profileService: profileService,
            userId: userId
        )
        
        let reviewsViewModel = ReviewsContentViewModel(
            profileService: profileService,
            userId: userId
        )
        
        let bookmarksViewModel = BookmarksContentViewModel(
            profileService: profileService,
            userId: userId
        )
        
        let tabBarViewModel = TabBarViewModel(
            tabItems: [
                TabItemDTO(id: .lives, icon: "icon-play", text: "Lives", isSelected: true),
                TabItemDTO(id: .reviews, icon: "icon-star-1", text: "Reviews"),
                TabItemDTO(id: .bookmarks, icon: "icon-heart-dark", text: "Saved")
            ]
        )
        
        return ProfileViewModel(
            profileService: profileService,
            userId: userId,
            tabBarViewModel: tabBarViewModel,
            livesViewModel: livesViewModel,
            reviewsViewModel: reviewsViewModel,
            bookmarksViewModel: bookmarksViewModel,
            scenarioManager: scenarioManager
        )
    }
}
