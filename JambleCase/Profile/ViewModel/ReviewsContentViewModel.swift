import SwiftUI
import Combine

@MainActor
final class ReviewsContentViewModel: ObservableObject {
    @Published var reviews: [ReviewItemDTO] = []
    @Published var isLoading: Bool = true
    @Published var error: String?
    @Published var averageRating: Double = 0.0
    @Published var totalReviews: Int = 0

    private let profileService: ProfileServiceProtocol
    private let userId: String
    private var hasLoaded = false

    init(profileService: ProfileServiceProtocol, userId: String) {
        self.profileService = profileService
        self.userId = userId
    }

    var formattedRating: String {
        averageRating.truncatingRemainder(dividingBy: 1) == 0
            ? String(format: "%.0f", averageRating)
            : String(format: "%.1f", averageRating)
    }

    var formattedTotal: String {
        if totalReviews >= 1000 {
            return String(totalReviews)
        }
        return "\(totalReviews)"
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
            let content = try await profileService.loadReviewsContent(userId: userId)
            reviews = content.reviews
            averageRating = content.averageRating
            totalReviews = content.totalReviews
            isLoading = false
        } catch {
            self.error = error.localizedDescription
            isLoading = false
        }
    }
}
