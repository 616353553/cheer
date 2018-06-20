//
//  NERequestController.swift
//  cheer
//
//  Created by Kelong Wu on 2017/7/5.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import Foundation

class NERequestController{
    
    private var startPoint = "https://us-central1-cheerapp-7bbfe.cloudfunctions.net/"
    private var requests = [NERequestAction]()
    
    /**
     false: async request and response, only block at end of all the requests
     true:  block each request and start the next after handling response
     */
    
    private var isSequential: Bool = false
    private var requestDidEnd: (()->Void)?
    private var requestDidEndPresent: (()->Void)? // NOT IMPLEMENTED =
    private var requestWillBegin: (()->Void)?
    private var requestWillBeginMain: (()->Void)?
    
    // mutex lock is not used! not thread safe!
    private var counter: Int = 0
    private var tasks = [URLSessionDataTask]()

    /**
     
     Initializer
     
    - parameter beforeStart: Called just BEFORE all requests start on MAIN thread.
     
    - parameter callback: Called AFTER all the requests are done on MAIN thread.
     
     */
    
    init(isSequential: Bool = false, beforeStart:(()->Void)? = nil, callback: (()->Void)? = nil){
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
                    if action.verifyTimestamp(time: res["time"] as! String) {
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

