//
//  ServerError.swift
//  cheer
//
//  Created by bainingshuo on 2017/12/24.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import Foundation

public enum ServerError: String, Error {
    case noContent = "204"
    case badRequest = "400"
    case unauthorized = "401"
    case unknown
    
    public init(rawValue: String) {
        switch rawValue {
        case "204": self = .noContent
        case "400": self = .badRequest
        case "401": self = .unauthorized
        default: self = .unknown
        }
    }
}

extension ServerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noContent:
            return NSLocalizedString("Invalid response from server", comment: "This might be an implementation error in server")
        case .badRequest:
            return NSLocalizedString("Invalid request", comment: "")
        case .unauthorized:
            return NSLocalizedString("Permission denied", comment: "User token does not match")
        case .unknown:
            return NSLocalizedString("Unknown error, please try again later", comment: "Unknown error")
        }
    }
}


