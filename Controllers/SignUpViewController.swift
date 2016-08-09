//
//  SignUpViewController.swift
//  EventTask
//
//  Created by Harrison Woodward on 8/1/16.
//  Copyright © 2016 Harrison Woodward. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatTextField: UITextField!
    
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var accountButton: UIButton!
    
    let firebase = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor
        navigationItem.title = "Create Account"
        signUpButton.tintColor = fontColor
        accountButton.tintColor = fontColor
        addTapGesture()

    }
    
    func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action:
            #selector(SignInViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func createAccount(sender: AnyObject) {
        
        // add validation to entered fields
        
        if let emailAddress = emailAddressTextField.text, password = passwordTextField.text,
            repeatPassword = repeatTextField.text, phoneNumber = phoneTextField.text {
            
            if emailAddress.isValidEmail() {
                if phoneNumber.characters.count != 10{
                    print("invalid phone number. Ex: 2223334444")
                    return
                }
                
                if password != repeatPassword {
                    
                    self.presentAlertController("Error", message:
                        "Passwords does not match")
                    return
                }
                
                if password.characters.count < 7 {
                    self.presentAlertController("Error", message:
                        "Minimum length for password is 7 characters")
                    return
                }
                
                FIRAuth.auth()?.createUserWithEmail(emailAddress, password: password ) { (user, error) in
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        if error == nil {
                            if let user = FIRAuth.auth()?.currentUser {
                                let ref = FIRDatabase.database().reference()
                                let name = user.email!
                                let email = user.email!
                                let userID = user.uid;
                                
                                let fbUser = [
                                    "name": name,
                                    "email": email,
                                    "phonenumber": phoneNumber,
                                    "groups": [],
                                    "tasks": []]
                                
                                ref.child("Users").child(userID).setValue(fbUser)
                                ref.child("Phone Numbers").child(phoneNumber).setValue(userID)
                            }
                        
                        FIRAuth.auth()?.signInWithEmail(emailAddress, password: password) { (user, error) in
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
                                error!.localizedDescription)
                            return
                        }

                
                })
                
            }
        }
        
        }
    }
    
    @IBAction func alreadyHaveAccount(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
//        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewControllerWithIdentifier("SignInViewController")
//        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
}