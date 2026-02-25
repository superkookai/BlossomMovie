//
//  Errors.swift
//  BlossomMovie
//
//  Created by Weerawut on 24/2/2569 BE.
//

import Foundation

enum APIConfigError: Error, LocalizedError {
    case fileNotFound
    case dataLoadingFailed(underlyingError: Error)
    case decodingFailed(underlyingError: Error)
    
    var errorDescription: String? {
        switch self {
            case .fileNotFound:
            return "File not found"
        case let .dataLoadingFailed(underlyingError: underlyingError):
            return "Data loading failed: \(underlyingError.localizedDescription)"
        case let .decodingFailed(underlyingError: underlyingError):
            return "Decoding failed: \(underlyingError.localizedDescription)"
        }
    }
}

enum NetworkError: Error, LocalizedError {
    case badURLResponseError(undelyingError: Error)
    case missingConfigError
    case urlBuildFailed
    
    var errorDescription: String? {
        switch self {
        case let .badURLResponseError(undelyingError: underlyingError):
            return "Bad URL response: \(underlyingError.localizedDescription)"
        case .missingConfigError:
            return "Missing API configuration"
        case .urlBuildFailed:
            return "URL build failed"
        }
    }
}
