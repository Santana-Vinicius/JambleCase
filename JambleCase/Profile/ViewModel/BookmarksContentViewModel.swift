import SwiftUI
import Combine

@MainActor
final class BookmarksContentViewModel: ObservableObject {
    @Published var items: [BookmarkItemDTO] = []
    @Published var isLoading: Bool = true
    @Published var error: String?

    private let profileService: ProfileServiceProtocol
    private let userId: String
    private var hasLoaded = false

    init(profileService: ProfileServiceProtocol, userId: String) {
        self.profileService = profileService
        self.userId = userId
    }

    @discardableResult
    func loadIfNeeded() -> Task<Void, Never>? {
        guard !hasLoaded else { return nil }
        hasLoaded = true
        return Task {
            await loadData()
        }
    }

    func refresh() async {
        await loadData()
    }

    private func loadData() async {
        isLoading = true
        error = nil
        
        do {
            items = try await profileService.loadBookmarksContent(userId: userId)
            isLoading = false
        } catch {
            self.error = error.localizedDescription
            isLoading = false
        }
    }
}
