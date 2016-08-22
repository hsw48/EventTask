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
import Crashlytics


class GroupsTableViewController: UITableViewController {
    var groupKeys = [String?]()
    var groupUrl = [String?]()
    var groups = [Group]()
    var ref : FIRDatabaseReference?
    var groupNames = [String]()
    var deleting = false

    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    @IBAction func logoutButtonPressed(sender: AnyObject) {
        let defaults = NSUserDefaults(suiteName: "session")
        if let _ = defaults?.objectForKey("auth") {
            defaults?.setObject(.None, forKey: "auth")
        }
        showSignInViewController()
    }
    
    override func viewDidLoad(){
        self.tableView.reloadData()
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
       
        if checkForUserSession() == .None {
            showSignInViewController()
            return
        }
        ref = FIRDatabase.database().reference()
        let CURRENT_USER_GROUPS_REF = ref!.child("Users").child((FIRAuth.auth()?.currentUser!.uid)!).child("groups")
        CURRENT_USER_GROUPS_REF.observeEventType(.Value, withBlock: { snapshot in
            
                //create array of user's groups
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
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            print("deleting")
            deleting = true
            let row = indexPath.row
            let ref = FIRDatabase.database().reference()
           // tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            var deletedTaskIds = [String]()
            var members = [String]()
            let tasksRef = ref.child("Groups").child(groupKeys[row]!).child("tasks")
            tasksRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    for snap in snapshots {
                deletedTaskIds.append(snap.key)
                    }
                for task in deletedTaskIds {
                    print("task \(task)")
                    let idRef = ref.child("Tasks").child(task).child("userIdClaimed")
                    idRef.observeEventType(.Value, withBlock: { snapshot in
                    if snapshot.exists() {
                            print("user \(snapshot.value as! String)")
                            ref.child("Users").child(snapshot.value as! String).child("tasks").child(task).removeValue()
                        }
                            ref.child("Tasks").child(task).removeValue()
                        })}
                    }
                    })
        
            let membersRef = ref.child("Groups").child(groupKeys[row]!).child("userIds")
            membersRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                print("member \(snapshot.value!)")
                members = snapshot.value as! [String]
                print("members \(members)")
                for member in members {
                    print("member: \(member)")
                    ref.child("Users").child(member).child("groups").child(self.groupKeys[row]!).removeValue()
                }

                ref.child("Groups").child(self.groupKeys[row]!).removeValue()
                self.groupKeys.removeAtIndex(row)
                self.groupNames.removeAtIndex(row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
             
            })
            

        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GroupCell", forIndexPath: indexPath) as! GroupTableViewCell
        let row = indexPath.row
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
        print("deleting = \(deleting)")
        if deleting {
            deleting = false
            return
        }else {
            if segue.identifier == "displayGroup" {
                print("displaying group")
                let displayGroupViewController = segue.destinationViewController as! DisplayGroupViewController
                let indexPath = tableView.indexPathForSelectedRow!
                let groupId = groupKeys[indexPath.row]
 
                let newGroup = Group(name: self.groupNames[indexPath.row])
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
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : UIViewController = storyboard.instantiateViewControllerWithIdentifier("SignInViewController")
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
}

