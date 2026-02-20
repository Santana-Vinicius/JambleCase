import Foundation

final class ProfileRepository: ProfileRepositoryProtocol {
    private let dataSource: ProfileDataSourceProtocol
    
    init(dataSource: ProfileDataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    func getProfile(userId: String) async throws -> ProfileResponse {
        do {
            return try await dataSource.fetchProfile(userId: userId)
        } catch let error as DataSourceError {
            throw mapToDataLayerError(error)
        } catch {
            throw DataLayerError.unknown(underlying: error)
        }
    }
    
    func getReviews(userId: String) async throws -> ReviewsResponse {
        do {
            return try await dataSource.fetchReviews(userId: userId)
        } catch let error as DataSourceError {
            throw mapToDataLayerError(error)
        } catch {
            throw DataLayerError.unknown(underlying: error)
        }
    }
    
    func getLives(userId: String) async throws -> [LiveResponse] {
        do {
            return try await dataSource.fetchLives(userId: userId)
        } catch let error as DataSourceError {
            throw mapToDataLayerError(error)
        } catch {
            throw DataLayerError.unknown(underlying: error)
        }
    }
    
    func getBookmarks(userId: String) async throws -> [BookmarkResponse] {
        do {
            return try await dataSource.fetchBookmarks(userId: userId)
        } catch let error as DataSourceError {
            throw mapToDataLayerError(error)
        } catch {
            throw DataLayerError.unknown(underlying: error)
        }
    }
    
    private func mapToDataLayerError(_ error: DataSourceError) -> DataLayerError {
        switch error {
        case .networkUnavailable:
            return .networkError(underlying: error)
        case .timeout:
            return .timeout
        case .notFound:
            return .notFound
        case .serverError:
            return .networkError(underlying: error)
        case .decodingFailed:
            return .decodingFailed(underlying: error)
        }
    }
}
