//
//  SwiftRequest.swift
//  SwiftRequestTest
//
//  Created by Ricky Robinett on 6/20/14.
//  Copyright (c) 2015 Ricky Robinett. All rights reserved.
//

import Foundation

open class SwiftRequest {
    var session = URLSession.shared
    
    public init() {
        // we should probably be preparing something here...
    }
    
    // GET requests
    open func get(_ url: String, auth: [String: String] = [String: String](), params: [String: String] = [String: String](), callback: ((_ err: NSError?, _ response: HTTPURLResponse?, _ body: AnyObject?)->())? = nil) {
        let qs = dictToQueryString(params)
        request(["url" : url, "auth" : auth, "querystring": qs ], callback: callback )
    }
    
    // POST requests
    open func post(_ url: String, data: [String: String] = [String: String](), auth: [String: String] = [String: String](), callback: ((_ err: NSError?, _ response: HTTPURLResponse?, _ body: AnyObject?)->())? = nil) {
        var qs = dictToQueryString(data)
        request(["url": url, "method" : "POST", "body" : qs, "auth" : auth] , callback: callback)
    }
    
    // Actually make the request
    func request(_ options: [String: Any], callback: ((_ err: NSError?, _ response: HTTPURLResponse?, _ body: AnyObject?)->())?) {
        if( options["url"] == nil ) { return }
        
        var urlString = options["url"] as! String
        if( options["querystring"] != nil && (options["querystring"] as! String) != "" ) {
            var qs = options["querystring"] as! String
            urlString = "\(urlString)?\(qs)"
        }
        
        var url = URL(string:urlString)
        var urlRequest = NSMutableURLRequest(url: url!)
        
        if( options["method"] != nil) {
            urlRequest.httpMethod = options["method"] as! String
        }
        
        if( options["body"] != nil && options["body"] as! String != "" ) {
            var postData = (options["body"] as! String).data(using: String.Encoding.ascii, allowLossyConversion: true)
            urlRequest.httpBody = postData
            urlRequest.setValue("\(postData!.count)", forHTTPHeaderField: "Content-length")
        }
        
        // is there a more efficient way to do this?
        if( options["auth"] != nil && (options["auth"] as! [String: String]).count > 0) {
            var auth = options["auth"] as! [String: String]
            if( auth["username"] != nil && auth["password"] != nil ) {
                var username = auth["username"]
                var password = auth["password"]
                //var authEncoded = "\(username!):\(password!)".dataUsingEncoding(String.Encoding.ascii, allowLossyConversion: true)!.base64EncodedStringWithOptions(NSData.Base64EncodingOptions.allZeros);
                var authEncoded = "\(username!):\(password!)".data(using: String.Encoding.ascii, allowLossyConversion: true)!.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
                //println(authEncoded)
                //print(authEncoded)
                var authValue = "Basic \(authEncoded)"
                urlRequest.setValue(authValue, forHTTPHeaderField: "Authorization")
            }
        }
        
        let task = session.dataTask(with: urlRequest as URLRequest, completionHandler: {body, response, err in
            var resp = response as! HTTPURLResponse?
            
            if( err == nil) {
                if(response?.mimeType == "text/html") {
                    var bodyStr = NSString(data: body!, encoding:String.Encoding.utf8.rawValue)
                    return callback!(err as NSError?, resp, bodyStr)
                } else if(response?.mimeType == "application/json") {
                    var localError: NSError?
                    //var json: AnyObject! = JSONSerialization.JSONObjectWithData(body! as NSData, options: JSONSerialization.ReadingOptions.MutableContainers, error: &localError)
                    var json: AnyObject!
                    do {
                        json = try JSONSerialization.jsonObject(with: body! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! AnyObject
                    }catch {
                        
                    }
                    return callback!(err as NSError?, resp, json);
                }
            }
            
            return callback!(err as NSError?, resp, body as AnyObject?)
        })
        
        task.resume()
    }
    
    func request(_ url: String, callback: ((_ err: NSError?, _ response: HTTPURLResponse?, _ body: AnyObject?)->())? = nil) {
        request(["url" : url ], callback: callback )
    }

    fileprivate func dictToQueryString(_ data: [String: String]) -> String {

        var qs = ""
        for (key, value) in data {
            let encodedKey = encode(key)
            let encodedValue = encode(value)
            qs += "\(encodedKey)=\(encodedValue)&"
        }
        return qs
    }
    
    fileprivate func encode(_ value: String) -> String {
        let queryCharacters =  CharacterSet(charactersIn:" =\"#%/<>?@\\^`{}[]|&+").inverted
        
        let encodedValue:String = value.addingPercentEncoding(withAllowedCharacters: queryCharacters)!
        
        return encodedValue
    }
}
