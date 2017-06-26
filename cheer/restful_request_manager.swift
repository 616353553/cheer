//
//  restful_request_manager.swift
//  cheer
//
//  Created by Kelong Wu on 2017/6/21.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import Foundation

/**
 - attention:
 you must implement getResultFromData, and presentResult to get it work
 */
protocol RestfulRequestManagerDelegate {
    /**
     A method in the request procedure to transform the given JSON-like data-level object to a well-defined representation-level object
        - parameters:
            - data: a NSObject that is genereted from JSON, might be a dictionary, array, or String
        - returns:
        Any object representing the final data that needs to be updated to view
     */
    func getResultFromData(data: Any)->Any
    /**
    A method to update the view using a representation-level data object
    Coonect the view or view data translator with the ready data.
     The view should be properly updated after this method.
     All the method will be excuted asnc on the main queue due to the limitation of "all UI related work should be done on the main queue"
     - parameters:
        - data: a well-defined representation-level object created by getResultFromData()
     */
    func presentResult(result: Any)
}


class RestfulRequestManager{
    
    var delegate: RestfulRequestManagerDelegate?
    var startPoint = "https://us-central1-cheerapp-7bbfe.cloudfunctions.net/"
    var timestampIsActive = true
    var now: String = ""
    
    func timestampFilter(timestamp: String)->Bool{
        if timestampIsActive{
            if timestamp == now{
                return true
            } else {
                return false
            }
        } else {
            return true
        }
    }
    
    /**
        Sending request to the website with endPoint 
        
        - parameters:
            - endPoint: the endPoint to send to. For example, "section" means send
                        request to "www.cheer.com/section"
            - parames: a dictionary of parameters {"time": "13412335", "query": "CS 225"} for example
     */
    func request(endPoint: String, params: [String:String]){
        guard let url = URL(string: startPoint + endPoint) else{
            print("DEBUG: invalid formatted url")
            return
        }
        
        guard let d = delegate else {
            print("no delegate avaliable")
            return
        }
        
        var parameters = params
        
        var request = URLRequest(url: URL(string: startPoint + endPoint)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let session = URLSession.shared
        
        // update current timestamp
        now = String(Int64(Date().timeIntervalSince1970 * 1000))
        parameters["time"] = now
        
        do {
            let jsonObject = try JSONSerialization.data(withJSONObject: parameters)
            request.httpBody = jsonObject
            if let JSONString = String(data: jsonObject, encoding: String.Encoding.utf8) {
                print(JSONString)
            }
            
            
            // this method requires a time and data key in the
            // res data
            let task = session.dataTask(with: request){
                (data, res, err) in
                
                do{
                    let res = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                    
                    
                    let result = self.delegate!.getResultFromData(data: res["data"])
                    if self.timestampFilter(timestamp: res["time"] as! String){
                        DispatchQueue.main.async {
                            self.delegate!.presentResult(result: result)
                            //self.tableViewData = result
                            //self.tableView.reloadData()
                        }
                    }
                } catch{
                    print("response data cannot be converted to valid JSON string")
                }
                
            }
            task.resume()
            
        } catch {
            print("params cannot be converted to valid JSON string")
            print("params:")
            print(params)
        }
    }
}
