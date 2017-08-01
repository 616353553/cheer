//
//  Authorization.swift
//  cheer
//
//  Created by bainingshuo on 2017/6/17.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import Foundation
import FirebaseAuth


/**
 The class which only dealing with the sign in/sign up/ reset password.
 */
class Authorization{
    
    /**
     Sign in with the given information, all user interaction will be disabled during the process, and an UIAlert will be shown if the action failed.
     
     - parameter email: Email address.
     
     - parameter password: Password.
     
     - parameter vc: The view controller which calls this function.
     
     - parameter completion: A closure which will be excuted after the process finishes.
     
     - parameter user: An object which represents current user if sign in succeed.
     
     - parameter error: An object which repesents error if sign in failed.
     
     */
    static func signIn(email: String!, password: String!, vc: UIViewController, completion: @escaping (_ user: User?, _ error: Error?)->()){
        let spinner = UIActivityIndicatorView()
        Spinner.enableActivityIndicator(activityIndicator: spinner, vc: vc, disableInteraction: true)
        Auth.auth().signIn(withEmail: email, password: password){(user, error) in
            Spinner.disableActivityIndicator(activityIndicator: spinner, enableInteraction: true)
            if error != nil{
                Alert.displayAlertWithOneButton(title: "Error", message: error!.localizedDescription, vc: vc)
            }
            // excute completion block
            DispatchQueue.main.async{
                completion(user, error)
            }
        }
    }
    
    
    
    
    
    
    
    /**
     Sign up with the given information, all user interaction will be disabled during the process, and an UIAlert will be shown if the action failed.
     
     - parameter email: Email address.
     
     - parameter password: Password.
     
     - parameter vc: The view controller which calls this function.
     
     - parameter completion: A closure which will be excuted after the process finishes.
     
     - parameter user: An object which represents current user if sign in succeed.
     
     - parameter error: An object which repesents error if sign in failed.
     */
    static func signUp(email: String!, password: String!, vc: UIViewController, completion: @escaping (_ user: User?, _ error: Error?)->()){
        let spinner = UIActivityIndicatorView()
        Spinner.enableActivityIndicator(activityIndicator: spinner, vc: vc, disableInteraction: true)
        Auth.auth().createUser(withEmail: email!, password: password, completion: {(user, error) in
            if user != nil{
                user!.sendEmailVerification(completion: {(error) in
                    // WARNING: error is not handled
                })
            } else {
                Alert.displayAlertWithOneButton(title: "Error", message: error!.localizedDescription, vc: vc)
            }
            Spinner.disableActivityIndicator(activityIndicator: spinner, enableInteraction: true)
            // excute completion block
            DispatchQueue.main.async{
                completion(user, error)
            }
        })
    }
    
    
    
    
    
    
    
    /**
     Send reset password email to the given address, all user interaction will be disabled during the process, and an UIAlert will be shown if the action failed.
     
     - parameter email: Email address.
     
     - parameter vc: The view controller which calls this function.
     
     - parameter completion: A closure which will be excuted after the process finishes.
     
     - parameter error: An object which repesents error if sending email failed.
     */
    static func resetPassword(email: String!, vc: UIViewController, completion: @escaping (_ error: Error?)->()){
        let spinner = UIActivityIndicatorView()
        Spinner.enableActivityIndicator(activityIndicator: spinner, vc: vc, disableInteraction: true)
        Auth.auth().sendPasswordReset(withEmail: email, completion: {(error) in
            Spinner.disableActivityIndicator(activityIndicator: spinner, enableInteraction: true)
            if error != nil{
                Alert.displayAlertWithOneButton(title: "Error", message: error!.localizedDescription, vc: vc)
            } else {
                Alert.displayAlertWithOneButton(title: "Success", message: "A link is sent to your email, please check your email", vc: vc)
            }
            // excute completion block
            DispatchQueue.main.async{
                completion(error)
            }
        })
    }
}
