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

//        let notificationTypes: UIUserNotificationType = [.Alert, .Badge, .Sound]
//        let pushNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
//        
//        application.registerUserNotificationSettings(pushNotificationSettings)
//        application.registerForRemoteNotifications()
       
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
    
//    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
//        // display the userInfo
//        if let notification = userInfo["aps"] as? NSDictionary,
//            let alert = notification["alert"] as? String {
//            var alertCtrl = UIAlertController(title: "New Task", message: alert as String, preferredStyle: UIAlertControllerStyle.Alert)
//            alertCtrl.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//            // Find the presented VC...
//            var presentedVC = self.window?.rootViewController
//            while (presentedVC!.presentedViewController != nil)  {
//                presentedVC = presentedVC!.presentedViewController
//            }
//            presentedVC!.presentViewController(alertCtrl, animated: true, completion: nil)
//            
//            // call the completion handler
//            // -- pass in NoData, since no new data was fetched from the server.
//            completionHandler(UIBackgroundFetchResult.NoData)
//        }
//    }
//    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
//        if notificationSettings.types != .None {
//            application.registerForRemoteNotifications()
//        }
//    }
//
//    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
//        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
//        var tokenString = ""
//        
//        for i in 0..<deviceToken.length {
//            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
//        }
//        
//        print("Device Token:", tokenString)
//    }
//    
//    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
//        print("Failed to register:", error)
//    }
//
//    private func convertDeviceTokenToString(deviceToken:NSData) -> String {
//        //  Convert binary Device Token to a String (and remove the <,> and white space charaters).
//        var deviceTokenStr = deviceToken.description.stringByReplacingOccurrencesOfString(">", withString: "")
//        deviceTokenStr = deviceTokenStr.stringByReplacingOccurrencesOfString("<", withString: "")
//        deviceTokenStr = deviceTokenStr.stringByReplacingOccurrencesOfString(" ", withString: "")
//        
//        // Our API returns token in all uppercase, regardless how it was originally sent.
//        // To make the two consistent, I am uppercasing the token string here.
//        deviceTokenStr = deviceTokenStr.uppercaseString
//        return deviceTokenStr
//    }
    

    
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

