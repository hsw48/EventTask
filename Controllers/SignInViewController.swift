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
        // Dispose of any resources that can be recreated.
    }
    
    /*!
     @abstract Sent to the delegate when the button was used to logout.
     @param loginButton The button that was clicked.
     */
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!){
        print("Logging out")
    }
    
    /*!
     @abstract Sent to the delegate when the button is about to login.
     @param loginButton the sender
     @return YES if the login should be allowed to proceed, NO otherwise
     */
//    override func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool
//}

    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
