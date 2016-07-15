//
//  SignInViewController.swift
//  EventTask
//
//  Created by Harrison Woodward on 7/14/16.
//  Copyright © 2016 Harrison Woodward. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit


class SignInViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var loginButton: UIButton!
  
    
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
   

    
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError?) {
        print("Logging in")
        if let error = error {
            print("error: " + error.localizedDescription)
            return
        }
        let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
        FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
    
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let user = FIRAuth()?.currentUser {
            
        }
        
        
        
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if user != nil {
                print("success")
               performSegueWithIdentifier("loggedIn", sender: self)
            } else {
                self.facebookLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
                self.facebookLoginButton.delegate = self
            }
        }
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
