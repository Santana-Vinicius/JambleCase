import Foundation

final class MockProfileDataSource: ProfileDataSourceProtocol {
    var config: MockDataSourceConfig
    
    init(config: MockDataSourceConfig = MockDataSourceConfig()) {
        self.config = config
    }
    
    func fetchProfile(userId: String) async throws -> ProfileResponse {
        try await simulateNetworkBehavior()
        return try JSONLoader.load("\(config.scenario.filePrefix)profile", as: ProfileResponse.self)
    }
    
    func fetchReviews(userId: String) async throws -> ReviewsResponse {
        try await simulateNetworkBehavior()
        return try JSONLoader.load("\(config.scenario.filePrefix)reviews", as: ReviewsResponse.self)
    }
    
    func fetchLives(userId: String) async throws -> [LiveResponse] {
        try await simulateNetworkBehavior()
        
        struct LivesContainer: Codable {
            let lives: [LiveResponse]
        }
        
        let container = try JSONLoader.load("\(config.scenario.filePrefix)lives", as: LivesContainer.self)
        return container.lives
    }
    
    func fetchBookmarks(userId: String) async throws -> [BookmarkResponse] {
        try await simulateNetworkBehavior()
        
        struct BookmarksContainer: Codable {
            let bookmarks: [BookmarkResponse]
        }
        
        let container = try JSONLoader.load("\(config.scenario.filePrefix)bookmarks", as: BookmarksContainer.self)
        return container.bookmarks
    }
    
    private func simulateNetworkBehavior() async throws {
        if config.shouldSimulateDelay {
            let delay = Double.random(in: config.delayRange)
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }
        
        if config.errorRate > 0 && Double.random(in: 0...1) < config.errorRate {
            throw config.errorTypes.randomElement() ?? DataSourceError.networkUnavailable
        }
    }
}
