//
//  ChatMainVC.swift
//  cheer
//
//  Created by bainingshuo on 2017/8/11.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import JSQMessagesViewController

class ChatMainVC: JSQMessagesViewController {

    private var userProfile: UserProfile!
    var tasks: [Message]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard Auth.auth().currentUser != nil else {
            fatalError("Error: User must be signed in to chat")
        }
        userProfile = UserProfile()
        userProfile.initialize(uid: Auth.auth().currentUser!.uid)
        userProfile.fetchDataFromUID(){ (snapshot) in
            if snapshot.exists() {
                self.senderId = self.userProfile.getUID()
                self.senderDisplayName = self.userProfile.getNickname()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
