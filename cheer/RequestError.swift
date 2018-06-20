//
//  RequestError.swift
//  cheer
//
//  Created by bainingshuo on 2017/12/23.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import Foundation

public enum RequestError: Error {
    case invalidHttpBody
    case invalidMediaType
    case stringToDataFail
    case JSONToStringFail
    case invalidURL
}

extension RequestError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidHttpBody:
            return NSLocalizedString("Invalid http body", comment: "Upload data with unsupported type")
        case .invalidMediaType:
            return NSLocalizedString("Invalid media type", comment: "Upload media with types besides [String: Media], [String: [Media]] or [String: [String: Media]]")
        case .stringToDataFail:
            return NSLocalizedString("Failed converting text", comment: "Failed to convert String to Data")
        case .JSONToStringFail:
            return NSLocalizedString("Failed converting data", comment: "Failed to convert JSON to String")
        case .invalidURL:
            return NSLocalizedString("Invalid url", comment: "Failed to create url")
        }
    }
}
