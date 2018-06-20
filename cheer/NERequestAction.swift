//
//  NERequestAction.swift
//  cheer
//
//  Created by bainingshuo on 2017/12/20.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import Foundation

class NERequestAction{
    
    let endPoint: String?
    var httpBody: Data?
    
    // handler or delegates or whatever
    var dataWillLoad: ((Data?)->Void)?
    var dataDidLoad: ((Any?)->Void)?
    var viewWillUpdate: ((Any?, Any?, Error?)->Void)?
    
    
    /**
     
     A boolean value decides if the timestamp is activated or not.
     When the tiemstamp is enabled, only the newest, called "now", request's response will be proceded.
     It's usually used to address the i-layer or d-layer misrepresenting problem.
     
     */
    //var timestampIsActive = false
    var now: String = ""
    
    
    
    /**
     
     Init of an NERequestAction. It represents a single HTTP request with JSON in and out
     it must be added to NERequestController to send the request
     
     - parameter endPoint: The endPoint of url, that is 'function name' on backend
     - parameter httpBody: A JSON-encodable object as the content of the request
     - parameter handler: callback function handling the response of URL request on the MAIN thread. If you need to handle it on background thread, use NERequestAction.dataDidLoad intead. Below is the list of parameters of the callback function.
     1. data:Any? Response data from server as JSON-encodable object
     2. serverError: Any? Error from server as JSON-encodable object
     3. requestError: Error? Error from request
     
     */
    
    init(endPoint: String, httpBody: Any?, handler: ((Any?, Any?, Error?)->Void)? = nil) {
        self.endPoint = endPoint
        if httpBody != nil {
            let extendObj = ["data": httpBody!, "time": String(Int64(Date().timeIntervalSince1970 * 1000))]
            do {
                self.httpBody = try JSONSerialization.data(withJSONObject: extendObj)
            } catch {
                print("Invalid JSON format")
            }
        }
        self.viewWillUpdate = handler
    }
    
    

    
    /**
     
     Hepler function which prints out the httpBody
     
     */
    
    func printHttpBody() {
        guard self.httpBody != nil else {
            print("httpbody is nil")
            return
        }
        if let JSONString = String(data: httpBody!, encoding: String.Encoding.utf8) {
            print("HttpBody:" + JSONString)
        } else {
            print("HttpBody is invalid")
        }
    }
    
    
    
    
    /**
     
     Verify if the timestamp given is "now" time. As long as the string match, we assume it is now.
     
     - time: time need to be verified
     - returns: true if the time given is same as "now" timestampe
     false otherwise
     
     */
    
    func verifyTimestamp(time: String)->Bool{
        return self.now == time
    }
    
}
