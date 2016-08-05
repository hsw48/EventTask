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


class SignInViewController: UIViewController /* FBSDKLoginButtonDelegate */ {

    @IBOutlet weak var loginButton: UIButton!

    @IBOutlet weak var statementLabel: UILabel!
    
 //   @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    
    @IBOutlet weak var emailAddressTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var createAccount: UIButton!
    @IBOutlet weak var password: UIButton!
    
   let firebase = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor
        statementLabel.backgroundColor = backgroundColor
        addTapGesture()
        signIn.tintColor = fontColor
        createAccount.tintColor = fontColor
        password.tintColor = fontColor
   
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action:
            #selector(SignInViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func forgetPassword(sender: AnyObject) {
        if let emailAddress = emailAddressTextField.text {
            
            if emailAddress.isValidEmail() {
                FIRAuth.auth()?.sendPasswordResetWithEmail(emailAddress) { (error) in
                    dispatch_async(dispatch_get_main_queue(), {
                        if let error = error {
                            self.presentAlertController("Error", message:
                                error.localizedDescription)
                        } else {
                            self.presentAlertController("Password Reset", message:
                                "Password has been sent to your email address")
                        }
                    })
                }
            } else {
                self.presentAlertController("Error", message:
                    "Invalid EmailAddress")
            }
        }
    }
    
    @IBAction func signIn(sender: AnyObject) {
        
        if let emailAddress = emailAddressTextField.text,
            password = passwordTextField.text {
            if emailAddress.isValidEmail() {
                FIRAuth.auth()?.signInWithEmail(emailAddress, password: password)
                { (user, error) in
                    dispatch_async(dispatch_get_main_queue(), {
                        if error == nil {
                            saveSession(user!.uid)
                              self.dismissViewControllerAnimated(true, completion: nil)
                           
                        } else {
                            self.presentAlertController("Error", message:
                                error!.localizedDescription)
                            
                            self.emailAddressTextField.text = ""
                            self.passwordTextField.text = ""
                        }
                    })
                }
            } else {
                
                self.presentAlertController("Error", message:
                    "Invalid EmailAddress")
            }
        }
    }

    
    @IBAction func dontHaveAccount(sender: AnyObject) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("SignUpViewController")
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    //my facebook code
    
    
    
    
    var logoutIndex : Int = 0
    var phoneNumberIndex : Int = 0

//    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
//        print("Logging in")
//        print("logout index \(logoutIndex)")
//        if let error = error {
//            print("error: " + error.localizedDescription)
//            return
//        } else if result.isCancelled {
//            //back to login screen
//        }
//        else{
//            
//            let ref = FIRDatabase.database().reference()
//            let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
//            
//            FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
//                print("Signing in with credential")
//                if error != nil {
//                    print(error)
//                    return
//                } else if ref.child("Users").valueForKey((FIRAuth.auth()?.currentUser!.uid)!)!.exists() {
//                    self.logoutIndex = 0
//                    self.dismissViewControllerAnimated(true, completion: nil)
//                    return
//                    
//                }else{
//                self.logoutIndex = 0
//                    print("logout index else \(self.logoutIndex)")
//                    if let user = FIRAuth.auth()?.currentUser {
//                        self.phoneNumberIndex = 1
//                        let name = user.displayName!
//                        let email = user.email!
//                        //let photoUrl = user.photoURL!
//                        let userID = user.uid;
//      
//                        let fbUser = ["uid": userID,
//                                      "name": name,
//                                      "email": email,
//                                      "groups": [],
//                                      "tasks": []]
//                        
//                        ref.child("Users").child(userID).setValue(fbUser)
//                   self.dismissViewControllerAnimated(true, completion: nil)
//                        
//                    }
//                }
//            }
//            
//        }
//        
//        
//    }
    
    override func viewDidAppear(animated: Bool) {
//        print("logout index appear \(logoutIndex)")
//        if FIRAuth.auth()?.currentUser?.uid != nil && logoutIndex == 0 {
//            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc : UITabBarController = storyboard.instantiateViewControllerWithIdentifier("TabBarViewController") as! UITabBarController
//            self.presentViewController(vc, animated: true, completion: nil)
       // }
    }

    
  //  override func viewDidLoad() {
//        print("logout index load \(logoutIndex)")
//        if FIRAuth.auth()?.currentUser?.uid != nil && logoutIndex == 0 {
//            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc : UITabBarController = storyboard.instantiateViewControllerWithIdentifier("TabBarViewController") as! UITabBarController
//            self.presentViewController(vc, animated: true, completion: nil)
//        }
  //     super.viewDidLoad()
       
        
       // let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissKeyboard))
        
       // view.addGestureRecognizer(tap)
        
 //       facebookLoginButton.delegate = self
      
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
 
 //   }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      
    }
//    
//    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!){
//        print("Logging out")
//    }


}
