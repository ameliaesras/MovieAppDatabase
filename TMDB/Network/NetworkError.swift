//
//  NetworkError.swift
//  TMDB
//
//  Created by Amelia Esra S on 01/02/23.
//  Copyright © 2023 Amelia Esra S. All rights reserved.
//

import Foundation

enum NetworkError: LocalizedError {
    case generalFailure
    case failedToParseData
    case dataIsNil
    case connectionFailed
    case outOfRange
    case apiError(String)
    var errorDescription: String? {
        switch self {
        case .failedToParseData:
            return "Technical Difficults, we can't fetch the data"
        default:
            return "Check your connectivity"
        }
    }
}
