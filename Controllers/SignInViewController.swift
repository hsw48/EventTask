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
    
   
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("Logging in")
        if let error = error {
            print("error: " + error.localizedDescription)
            return
        } else if result.isCancelled {
            //back to login screen
        }
        else{
            
            let ref = FIRDatabase.database().reference()
            let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
            
            FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                print("Signing in with credential")
                if error != nil {
                    print(error)
                    return
                } else if FIRAuth.auth()?.currentUser!.uid != nil {
                    return
                    
                }else{
                
                    if let user = FIRAuth.auth()?.currentUser {
                        
                        let name = user.displayName!
                        let email = user.email!
                        //let photoUrl = user.photoURL!
                        let userID = user.uid;
      
                        let fbUser = ["uid": userID,
                                      "name": name,
                                      "email": email,
                                      "groups": [],
                                      "tasks": []]
                        
                        ref.child("Users").child(userID).setValue(fbUser)
                    }
                }
            }
            
        }
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
       
    }
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
       // let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissKeyboard))
        
       // view.addGestureRecognizer(tap)
        
        facebookLoginButton.delegate = self
      
        
        
//        
//        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
//            if user != nil {
//                print("success")
//                let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                let homeViewController: UIViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("TabBarViewController")
//                self.presentViewController(homeViewController, animated: true, completion: nil)
//                
//            } else {
//                self.facebookLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
//                self.facebookLoginButton.delegate = self
//            }
//        }
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!){
        print("Logging out")
    }


}
