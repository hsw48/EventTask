//
//  AppDelegate.swift
//  EventTask
//
//  Created by Harrison Woodward on 7/13/16.
//  Copyright © 2016 Harrison Woodward. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit
import AddressBook
import Contacts
import Crashlytics
import Fabric



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
 
    override init(){
        super.init()
        FIRApp.configure()
        applyTheme()
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Fabric.with([Crashlytics.self])

        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

//       //  make sure user hadn't previously denied access
//        
//        let status = CNContactStore.authorizationStatusForEntityType(.Contacts)
//        if status == .Denied || status == .Restricted {
//            // user previously denied, so tell them to fix that in settings
//            print("denied or restricted")
//            return true
//        }
//        
//        // open it
//        
//        let store = CNContactStore()
//        store.requestAccessForEntityType(.Contacts) { granted, error in
//            guard granted else {
//                dispatch_async(dispatch_get_main_queue()) {
//                    // user didn't grant authorization, so tell them to fix that in settings
//                    print(error)
//                }
//                return
//            }
//            
//            // get the contacts
//            
//            var contacts = [CNContact]()
//            let request = CNContactFetchRequest(keysToFetch: [CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName), CNContactPhoneNumbersKey])
//            do {
//                try store.enumerateContactsWithFetchRequest(request) { contact, stop in
//                    contacts.append(contact)
//                }
//            } catch {
//                print(error)
//            }
//           
//            // do something with the contacts array (e.g. print the names)
//            
//            let formatter = CNContactFormatter()
//            formatter.style = .FullName
//            for contact in contacts {
//                print(formatter.stringFromContact(contact))
//            }

            
     //   }
        
       
            
        
        return true
    }

    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
 
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

