//
//  Request.swift
//  cheer
//
//  Created by bainingshuo on 2017/12/22.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import Foundation

enum RequestType {
    case multipart
    case json
}

class Request {
    
    private let startPoint = "https://us-central1-cheerapp-7bbfe.cloudfunctions.net/"
    private var requestType: RequestType!
    private var url: URL!
    private var userToken: String?
    private var boundary: String!
    private var httpBody = Data()
    private var timeStamp: Int!
    private var completion: (([String: Any]?, Error?)->Void)?
    private var initError: Error?
    
    
    
    
    /// Initialize request action.
    /// - Parameters:
    ///     - requestType: Type of this httpRequest, determines body's data type
    ///     - endPoint: The endPoint of url, that is 'function name' on backend
    ///     - body: The data needed to be sent to the server in [key: value] format, where the type of value can be String, [String], Media or [Media]
    ///     - completion: Callback function handling the response of URL request on the MAIN thread
    ///     - data: Response data from server as JSON-encodable object
    ///     - error: Error? Error from server or HTTPRequest
    
    init(requestType: RequestType, endPoint: String, body: [String: Any]?, userToken: String?, completion: (([String: Any]?, Error?)->Void)?) {
        if let url = URL(string: startPoint + endPoint) {
            self.url = url
        } else {
            self.initError = RequestError.invalidURL
        }
        self.requestType = requestType
        self.userToken = userToken
        self.boundary = "Boundary-\(UUID().uuidString)"
        self.timeStamp = Int(Date().timeIntervalSince1970 * 1000)
        self.completion = completion
        do {
            try setHttpBody(body: body)
        } catch {
            self.initError = error
        }
    }
    
    
    
    
    
    
    /// Get time stamp
    
    func getTimeStamp() -> Int {
        return self.timeStamp
    }
    
    
    
    
    /// Set http body from given raw body
    
    private func setHttpBody(body: [String: Any]?) throws {
        do {
            switch self.requestType! {
            case .multipart:
                try setMutipartHttpBody(body: body)
            case .json:
                try setJsonHttpBody(body: body)
            }
        } catch {
            throw error
        }
    }
    
    

    /// Set Http Body from given raw body in format of Json

    private func setJsonHttpBody(body: [String: Any]?) throws {
        if body != nil {
            do {
                self.httpBody = try JSONSerialization.data(withJSONObject: body!)
            } catch {
                throw error
            }
        }
    }
    
    
    
    
    
    /// Set Http Body from given raw body in format of mutipart
    
    private func setMutipartHttpBody(body: [String: Any]?) throws {
        if body != nil {
            for (key, val) in body! {
                do {
                    switch val {
                    case is String:
                        try self.httpBody.append(createStringBlock(key: key, val: val as! String))
                    case is [String]:
                        try self.httpBody.append(createStringArrayBlock(key: key, val: val as! [String]))
                    case is Media:
                        try self.httpBody.append(createMediaBlock(key: key, val: val as! Media))
                    case is [Media]:
                        try self.httpBody.append(createMediaArrayBlock(key: key, val: val as! [Media]))
                    default:
                        throw RequestError.invalidHttpBody
                    }
                } catch {
                    throw error
                }
            }
        }
        
        // add finish line to httpBody
        do {
            try self.httpBody.append(stringToData(text: "--\(self.boundary!)--\r\n"))
        } catch {
            throw error
        }
    }
    
    
    
    
    
    // create Data from given [String]
    
    private func createStringArrayBlock(key: String, val: [String]) throws -> Data {
        var dataBlock = Data()
        for (index, text) in val.enumerated() {
            do {
                try dataBlock.append(createStringBlock(key: "\(key)/\(index)", val: text))
            } catch {
                throw error
            }
        }
        return dataBlock
    }
    
    
    
    
    // create Data from given String
    
    private func createStringBlock(key: String, val: String) throws -> Data {
        var dataBlock = Data()
        do {
            try dataBlock.append(stringToData(text: "--\(self.boundary!)\r\n"))
            try dataBlock.append(stringToData(text: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n"))
            try dataBlock.append(stringToData(text: "\(val)\r\n"))
        } catch {
            throw error
        }
        return dataBlock
    }
    
    
    
    
    // create Data from given [Media]
    
    private func createMediaArrayBlock(key: String, val: [Media]) throws -> Data {
        var datablock = Data()
        for (index, media) in val.enumerated() {
            do {
                try datablock.append(createMediaBlock(key: "\(key)/\(index)", val: media))
            } catch {
                throw error
            }
        }
        return datablock
    }
    
    
    
    
    // create Data from given Media
    
    private func createMediaBlock(key: String, val: Media) throws -> Data {
        var dataBlock = Data()
        do {
            try dataBlock.append(stringToData(text: "--\(self.boundary!)\r\n"))
            try dataBlock.append(stringToData(text: "Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(val.filename)\"\r\n"))
            try dataBlock.append(stringToData(text: "Content-Type: \(val.mimeType.rawValue)\r\n\r\n"))
            dataBlock.append(val.data)
            try dataBlock.append(stringToData(text: "\r\n"))
        } catch {
            throw error
        }
        return dataBlock
    }
    
    
    
    
    // convert String to Data
    
    private func stringToData(text: String) throws -> Data {
        if let data = text.data(using: .utf8) {
            return data
        } else {
            throw RequestError.stringToDataFail
        }
    }
    
    
    
    
    /// Start sending http request
    
    func start() {
        // if there is error during initialization, do nothing but return the error
        if self.initError != nil && self.completion != nil{
            DispatchQueue.main.async {
                self.completion!(nil, self.initError!)
            }
            return
        }
        
        // set basic information of http request
        var request = URLRequest(url: self.url)
        request.httpMethod = "POST"
        request.addValue("\(self.userToken ?? "undefined")", forHTTPHeaderField: "Authorization")
        request.httpBody = self.httpBody
        
        // set header field(s) for http request based on requestType
        switch self.requestType! {
        case .multipart:
            request.setValue("multipart/form-data; boundary=\(self.boundary)", forHTTPHeaderField: "Content-Type")
        case .json:
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        }
        
        // send http request
        URLSession.shared.dataTask(with: request) { (data, response, requestError) in
            if self.completion == nil {
                return
            }
            
            // storing data and error for completion closure
            var completionData: [String: Any]?
            var completionError = requestError
            
            if data != nil {
                do {
                    let dataJSON = try JSONSerialization.jsonObject(with: data!) as? [String: Any]
                    if dataJSON != nil {
                        if let serverErrorCode = dataJSON!["error"] {
                            if serverErrorCode is String {
                                completionError = ServerError.init(rawValue: serverErrorCode as! String)
                            }
                        }
                        completionData = dataJSON!["data"] as? [String: Any]
                    }
                } catch {
                    completionError = error
                }
            }
            DispatchQueue.main.async {
                self.completion!(completionData, completionError)
            }
        }.resume()
    }
    
    
    
}
