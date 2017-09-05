//
//  NERequestController.swift
//  cheer
//
//  Created by Kelong Wu on 2017/7/5.
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
    var timestampIsActive = false
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

        [TEMPLATE OF HANDLER]
     
        {data,serverError, requestError in
     
            // do something
     
        }
     */
    init(endPoint: String, httpBody: Any? = nil, handler: ((Any?, Any?, Error?)->Void)? = nil) {
        self.endPoint = endPoint
        if let body = httpBody{
            if self.setHttpBody(obj: body){
                print("set Http Body Succeed!")
            }
        }
        self.viewWillUpdate = handler
    }
    
    /**
     
     Set httpbody
     
     - parameter obj: A JSON-encodable object representing the data. For example, ["data":[0,1]] is a valid object in this case
     
     - returns: Bool - true if in valid format, false otherwise
     
     */
    func setHttpBody(obj: Any)->Bool{
        guard JSONSerialization.isValidJSONObject(obj) else {
            print("invalid JSON File")
            return false
        }
        
        var extendObj = [String: Any]()
        extendObj["data"] = obj
        
        if timestampIsActive {
            now = String(Int64(Date().timeIntervalSince1970 * 1000))
            extendObj["time"] = now
        }
        
        do {
            self.httpBody = try JSONSerialization.data(withJSONObject: extendObj)
        } catch {
            print("Exception: NERequestAciton NO! Help!")
            return false
        }
        
        return true
    }
    
    /**
     
     Hepler function which prints out the httpBody
     */
    func printHttpBody(){
        guard self.httpBody != nil else {
            print("Error - Empty httpBody!")
            return
        }
        
        if let JSONString = String(data: httpBody!, encoding: String.Encoding.utf8) {
            print("BEGIN printHttpBody()")
            print(JSONString)
            print("END printHttpBody()")
        } else {
            print("Error - httpBody not in valid JSON format!")
        }
    }
    
    /**
     Verify if the timestamp given is "now" time. As long as the string match, we assume it is now.
     
     - time: time need to be verified
     - returns: true if the time given is same as "now" timestampe
     false otherwise
     
     */
    func verifyTimestamp(time: String?)->Bool{
        if time == nil {
            return false
        }
        
        if self.now == time {
            return true
        }
        
        return false
    }
    
}

class NERequestController{
    
    var startPoint = "https://us-central1-cheerapp-7bbfe.cloudfunctions.net/"
    var requests = [NERequestAction]()
    
    /**
     false: async request and response, only block at end of all the requests
     true:  block each request and start the next after handling response
     */
    
    var isSequential: Bool = false
    var requestDidEnd: (()->Void)?
    var requestDidEndPresent: (()->Void)? // NOT IMPLEMENTED =
    var requestWillBegin: (()->Void)?
    var requestWillBeginMain: (()->Void)?
    
    // mutex lock is not used! not thread safe!
    var counter: Int = 0
    var tasks = [URLSessionDataTask]()

    /**
     
     Initializer
     
    - parameter beforeStart: Called just BEFORE all requests start on MAIN thread.
     
    - parameter callback: Called AFTER all the requests are done on MAIN thread.
     
     */
    
    init(beforeStart:(()->Void)? = nil, callback: (()->Void)? = nil){
        requestDidEndPresent = callback
        requestWillBeginMain = beforeStart
    }
    
    /** 
     
    Add request to controller's queue
     
     */
    
    func add(request: NERequestAction){
        requests.append(request)
    }
    
    /**
    
     Dispatch requests in the order given
    
     */
    
    func sendRequests(){
        // do not support
        if counter > 0 {
            print("NERequestController in process, cannot take new request")
            return
        }
        
        counter = requests.count
        tasks = []
        
        if let requestWillBegin = self.requestWillBegin{
            requestWillBegin()
        }
        
        if let requestWillBeginmain = self.requestWillBeginMain{
            DispatchQueue.main.async {
                requestWillBeginmain();
            }
        }
        
        if requests.count == 0{
            
            if let end = self.requestDidEnd{
                end()
            }
            
            DispatchQueue.main.async {
                if let present = self.requestDidEndPresent{
                    present()
                }
                
            }
        }
        
        for (index, request) in requests.enumerated(){
            startRequest(action: request, i: index)
        }
        
        if let task = tasks.first {
            if isSequential {
                print("start of task 0")
                task.resume()
            }
        }
        
    }
    
    
    func startRequest(action: NERequestAction, i: Int){
        
        guard action.endPoint != nil else{
            print("DEBUG: no endPoint")
            return
        }
        
        guard URL(string: startPoint + action.endPoint!) != nil else{
            print("DEBUG: invalid formatted url")
            return
        }
        
        
        
        var request = URLRequest(url: URL(string: startPoint + action.endPoint!)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = action.httpBody
        
        let session = URLSession.shared
        
        
        let task = session.dataTask(with: request){
            (data, res, err) in
            
            // error
            
            if err != nil {
                if let viewWillUpdate = action.viewWillUpdate{
                    DispatchQueue.main.async {
                        // do nothing when data is not proceed, not crash though
                        viewWillUpdate(nil, nil, err)
                    }
                }
            } else {
                if let dataWillLoad  = action.dataWillLoad{
                    dataWillLoad(data)
                }
                do {
                    var res = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
        
                    print(action.verifyTimestamp(time: res["time"] as! String?))
                    print(action.timestampIsActive)
                    
                    if action.verifyTimestamp(time: res["time"] as! String?) == true || action.timestampIsActive == false {
                        // var result: Any?
                        if let dataDidLoad = action.dataDidLoad{
                            dataDidLoad(res["data"])
                        }
                        if let viewWillUpdate = action.viewWillUpdate{
                            DispatchQueue.main.async {
                                // do nothing when data is not proceed, not crash though
                                viewWillUpdate(res["data"], res["error"], nil)
                            }
                        }
                    }
                    
                } catch {
                    print("response data cannot be converted to valid JSON string")
                }
            }
            
            
            print("end of task \(i)")
            
            // this snippnet must be excuted even if there is an error occured
            self.counter = self.counter - 1
            if self.counter == 0 {
                print("end of ALL tasks")
                
                if let requestDidEnd = self.requestDidEnd{
                    print("end handler on background thread")
                    requestDidEnd()
                }
                
                if let didEndPresent = self.requestDidEndPresent{
                    DispatchQueue.main.async {
                        print("end handler on main thread")
                        didEndPresent();
                    }
                }
                
            } else {
                if self.isSequential {
                    // is this safe?
                    self.tasks[i + 1].resume()
                    print("start of task \(i + 1)")
                }
            }
        }
        
        if !isSequential {
            task.resume()
            print("start of task \(i)")
        } else {
            tasks.append(task)
        }
    }
}

