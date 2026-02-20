import Testing
@testable import JambleCase

@MainActor
struct ReviewsContentViewModelTests {
    var sut: ReviewsContentViewModel
    var mockService: MockProfileService

    init() {
        mockService = MockProfileService()
        sut = ReviewsContentViewModel(profileService: mockService, userId: "user_001")
    }

    @Test func initialState() {
        #expect(sut.reviews.isEmpty)
        #expect(sut.isLoading)
        #expect(sut.averageRating == 0.0)
        #expect(sut.totalReviews == 0)
        #expect(sut.error == nil)
    }

    @Test func loadIfNeeded_Success() async {
        let expectedReviews = [
            ReviewItemDTO(avatar: "avatar-1", username: "User1", rating: 5, timeAgo: "1h")
        ]
        mockService.mockReviewsContent = ReviewsContent(
            reviews: expectedReviews,
            averageRating: 4.8,
            totalReviews: 100
        )

        let task = sut.loadIfNeeded()
        await task?.value

        #expect(sut.reviews.count == 1)
        #expect(sut.averageRating == 4.8)
        #expect(sut.totalReviews == 100)
        #expect(!sut.isLoading)
        #expect(sut.error == nil)
        #expect(mockService.loadReviewsContentCallCount == 1)
    }

    @Test func formattedRating_Integer() {
        sut.averageRating = 5.0
        #expect(sut.formattedRating == "5")
    }

    @Test func formattedRating_Decimal() {
        sut.averageRating = 4.8
        #expect(sut.formattedRating == "4.8")
    }

    @Test func formattedTotal() {
        sut.totalReviews = 1234
        #expect(sut.formattedTotal == "1234")

        sut.totalReviews = 999
        #expect(sut.formattedTotal == "999")
    }

    @Test func refresh_Success() async {
        let expectedReviews = [
            ReviewItemDTO(avatar: "avatar-1", username: "User1", rating: 5, timeAgo: "1h")
        ]
        mockService.mockReviewsContent = ReviewsContent(
            reviews: expectedReviews,
            averageRating: 4.5,
            totalReviews: 50
        )

        await sut.refresh()

        #expect(sut.reviews.count == 1)
        #expect(sut.averageRating == 4.5)
        #expect(sut.totalReviews == 50)
        #expect(!sut.isLoading)
        #expect(mockService.loadReviewsContentCallCount == 1)
    }

    @Test func loadIfNeeded_Error() async {
        mockService.shouldThrowError = true

        let task = sut.loadIfNeeded()
        await task?.value

        #expect(sut.reviews.isEmpty)
        #expect(!sut.isLoading)
        #expect(sut.error != nil)
    }
}
