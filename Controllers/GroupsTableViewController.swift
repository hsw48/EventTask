//
//  GroupsTableViewController.swift
//  EventTask
//
//  Created by Harrison Woodward on 7/13/16.
//  Copyright © 2016 Harrison Woodward. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import FBSDKLoginKit


class GroupsTableViewController: UITableViewController {
    var groupKeys = [String?]()
    var groupUrl = [String?]()
    var groups = [Group]()
    var ref : FIRDatabaseReference?
    var groupNames = [String]()

    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    @IBAction func logoutButtonPressed(sender: AnyObject) {
        let defaults = NSUserDefaults(suiteName: "session")
        if let _ = defaults?.objectForKey("auth") {
            defaults?.setObject(.None, forKey: "auth")
        }
        showSignInViewController()

    }

    override func viewDidLoad(){
    // ref = FIRDatabase.database().reference()
        self.tableView.reloadData()
        super.viewDidLoad()
    //    self.groupNames = []
    
    }
    
    override func viewWillAppear(animated: Bool) {
       
        if checkForUserSession() == .None {
            print("called")
            showSignInViewController()
            return
        }
        print("view will appear")
        ref = FIRDatabase.database().reference()
        let CURRENT_USER_GROUPS_REF = ref!.child("Users").child((FIRAuth.auth()?.currentUser!.uid)!).child("groups")
        CURRENT_USER_GROUPS_REF.observeEventType(.Value, withBlock: { snapshot in
            
                //create array of user's groups
                print("callback")
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    var tempItems = [FIRDataSnapshot]()
                    self.groupKeys = []
                    self.groupUrl = []
                    for snap in snapshots {
                        tempItems.append(snap)
                    }
                    // get user's group keys
                    for item in tempItems {
                        self.groupKeys.append(item.key)
                    }
                    // get user's group urls
                    for item in tempItems {
                        self.groupUrl.append(String(item.value))
                    }
                    self.groupNames = []
                    self.tableView.reloadData()
                }
            })
        
    }
    
    override func viewDidAppear(animated: Bool){
        super.viewDidAppear(true)
      //  self.groupNames = []
      //  self.tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowCount = groupKeys.count
       // print("groupkeys : \(groupKeys.count)")
        return rowCount
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GroupCell", forIndexPath: indexPath) as! GroupTableViewCell
        let row = indexPath.row
        print("tableView")
        //set labels of group cells
        let ref = FIRDatabase.database().reference()
        let nameRef = ref.child("Groups").child(groupKeys[row]!).child("name")
        nameRef.observeEventType(.Value, withBlock: { snapshot in
            self.groupNames.append(String(snapshot.value!))
            cell.groupNameLabel.text = String(snapshot.value!)
        })
        let unclaimedRef = ref.child("Groups").child(groupKeys[row]!).child("noUnclaimed")
        unclaimedRef.observeEventType(.Value, withBlock: { snapshot in
            cell.noUnclaimedLabel.text = "\(String(snapshot.value!)) Unclaimed Tasks"
        })
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        
            if segue.identifier == "displayGroup" {
                let displayGroupViewController = segue.destinationViewController as! DisplayGroupViewController
                let indexPath = tableView.indexPathForSelectedRow!
                let groupId = groupKeys[indexPath.row]
                print("Displaying a group")
                
                let ref = FIRDatabase.database().reference()
            
                let groupRef = ref.child("Groups").child(groupId!)
                print("groupNames \(self.groupNames)")
                let newGroup = Group(name: self.groupNames[indexPath.row])
                               
                groupRef.child("noClaimed").observeEventType(.Value, withBlock: { snapshot in
                    newGroup.noClaimed = (snapshot.value as! Int)
                   // print("snapshot2 \(snapshot.value as! Int)")
                })
                groupRef.child("noOfMembers").observeEventType(.Value, withBlock: { snapshot in
                    newGroup.noOfMembers = (snapshot.value as! Int)
                   // print("snapshot3 \(snapshot.value as! Int)")
                })
                groupRef.child("noUnclaimed").observeEventType(.Value, withBlock: { snapshot in
                    newGroup.noUnclaimed = (snapshot.value as! Int)
                   // print("snapshot4 \(snapshot.value as! Int)")
                })
                groupRef.child("userNames").observeEventType(.Value, withBlock: { snapshot in
                   newGroup.userNames = (snapshot.value as! [String])
                  //  print("snapshot5 \(snapshot.value as! [String])")
                })
                groupRef.child("userIds").observeEventType(.Value, withBlock: { snapshot in
                    newGroup.userIds = (snapshot.value as! [String])
                 //   print("snapshot6 \(snapshot.value as! [String])")
                    
                })
                
                    displayGroupViewController.group = newGroup
                    displayGroupViewController.groupId = groupId
            }
         else if segue.identifier == "addGroup" {
                segue.destinationViewController as! CreateGroupViewController
            }
            else if segue.identifier == "logout" {
               let vc = segue.destinationViewController as! SignInViewController
                vc.logoutIndex = 1
        }
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        
    }
    func checkForUserSession() -> String? {
        let userDefaults = NSUserDefaults(suiteName: "session")
        if let auth =  userDefaults?.stringForKey("auth") {
            return auth
        }
        
        return .None
    }
    
    func showSignInViewController() {
        print("show signin")
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : UIViewController = storyboard.instantiateViewControllerWithIdentifier("SignInViewController")
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
}

