//
//  TabBarController.swift
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

class TabBarViewController: UITabBarController {
    
    override func viewDidAppear(animated: Bool) {
//        if FIRAuth.auth()?.currentUser?.uid == nil{
//            print("do it")
//            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc : UIViewController = storyboard.instantiateViewControllerWithIdentifier("SignInViewController")
//            self.presentViewController(vc, animated: true, completion: nil)
//        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : UIViewController = storyboard.instantiateViewControllerWithIdentifier("SignInViewController")
        self.presentViewController(vc, animated: true, completion: nil)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
