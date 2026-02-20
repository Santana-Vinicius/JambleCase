import Foundation

enum DataLayerError: LocalizedError {
    case networkError(underlying: Error)
    case notFound
    case decodingFailed(underlying: Error)
    case timeout
    case unknown(underlying: Error)
    
    var errorDescription: String? {
        switch self {
        case .networkError:
            return "Network connection failed"
        case .notFound:
            return "Content not found"
        case .decodingFailed:
            return "Failed to process data"
        case .timeout:
            return "Request timed out"
        case .unknown:
            return "An unexpected error occurred"
        }
    }
}

enum DataSourceError: Error {
    case networkUnavailable
    case timeout
    case notFound
    case serverError(code: Int)
    case decodingFailed
}
