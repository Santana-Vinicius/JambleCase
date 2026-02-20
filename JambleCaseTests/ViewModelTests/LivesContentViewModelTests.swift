import Testing
@testable import JambleCase

@MainActor
struct LivesContentViewModelTests {
    var sut: LivesContentViewModel
    var mockService: MockProfileService

    init() {
        mockService = MockProfileService()
        sut = LivesContentViewModel(profileService: mockService, userId: "user_001")
    }

    @Test func initialState() {
        #expect(sut.items.isEmpty)
        #expect(sut.isLoading)
        #expect(sut.error == nil)
    }

    @Test func loadIfNeeded_Success() async {
        let expectedLives = [
            LiveItemDTO(coverImage: "cover-1", title: "Live 1", badge: .live(viewers: 100), likes: 50)
        ]
        mockService.mockLives = expectedLives

        let task = sut.loadIfNeeded()
        await task?.value

        #expect(sut.items.count == 1)
        #expect(!sut.isLoading)
        #expect(sut.error == nil)
        #expect(mockService.loadLivesContentCallCount == 1)
    }

    @Test func loadIfNeeded_CalledOnlyOnce() async {
        mockService.mockLives = []

        let task = sut.loadIfNeeded()
        _ = sut.loadIfNeeded()
        _ = sut.loadIfNeeded()

        await task?.value

        #expect(mockService.loadLivesContentCallCount == 1)
    }

    @Test func refresh_Success() async {
        let expectedLives = [
            LiveItemDTO(coverImage: "cover-1", title: "Live 1", badge: .live(viewers: 100), likes: 50)
        ]
        mockService.mockLives = expectedLives

        await sut.refresh()

        #expect(sut.items.count == 1)
        #expect(!sut.isLoading)
        #expect(sut.error == nil)
        #expect(mockService.loadLivesContentCallCount == 1)
    }

    @Test func loadIfNeeded_Error() async {
        mockService.shouldThrowError = true

        let task = sut.loadIfNeeded()
        await task?.value

        #expect(sut.items.isEmpty)
        #expect(!sut.isLoading)
        #expect(sut.error != nil)
    }
}
