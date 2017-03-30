//
//  SendSMS.swift
//  cheer
//
//  Created by bainingshuo on 2017/3/22.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import Foundation
import SwiftRequest

class SendSMS{
    static func send(to: String, text: String, callback: ((_ err: NSError?, _ response: HTTPURLResponse?, _ body: AnyObject?)->())? = nil){
        let swiftRequest = SwiftRequest();
        let data = [
            "To" : to,
            "From" : "+12532851016",
            "Body" : text
        ];
        
        swiftRequest.post("https://api.twilio.com/2010-04-01/Accounts/ACfe949dd0c6fdd7b1653a00f4281bbcf0/Messages", data: data, auth: ["username" : Config.twilioSID, "password" : Config.twilioKey], callback: callback)
    }
}
