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
    var groupKeys = [String]()
    var groupUrl = [String]()

    @IBAction func logoutButtonPressed(sender: AnyObject) {
    }

    var groups = [Group]()

    var ref :FIRDatabaseReference?

    override func viewDidLoad(){
     ref = FIRDatabase.database().reference()
        
        self.tableView.reloadData()
        
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(animated: Bool) {
        ref = FIRDatabase.database().reference()
        
        let CURRENT_USER_GROUPS_REF = ref!.child("Users").child((FIRAuth.auth()?.currentUser!.uid)!).child("groups")
        CURRENT_USER_GROUPS_REF.observeEventType(.Value, withBlock: { snapshot in
            //create array of user's groups
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                var tempItems = [FIRDataSnapshot]()
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
                self.tableView.reloadData()
            }
        })
    }
    
    override func viewDidAppear(animated: Bool){
        super.viewDidAppear(true)
        
       
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
        print("groupkeys : \(groupKeys)")
        return rowCount
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GroupCell", forIndexPath: indexPath) as! GroupTableViewCell
        let row = indexPath.row
        
        // populate groups array with all of users groups
        // groups.append(  )
        
        //set labels of group cells
        let ref = FIRDatabase.database().reference()
        let nameRef = ref.child("Groups").child(groupKeys[row]).child("name")
        _ = nameRef.observeEventType(.Value, withBlock: { snapshot in
            cell.groupNameLabel.text = String(snapshot.value!)
        })
        let unclaimedRef = ref.child("Groups").child(groupKeys[row]).child("noUnclaimed")
        _ = unclaimedRef.observeEventType(.Value, withBlock: { snapshot in
            cell.noUnclaimedLabel.text = "Unclaimed Tasks: \(String(snapshot.value!))"
        })
        let membersRef = ref.child("Groups").child(groupKeys[row]).child("noOfMembers")
        _ = membersRef.observeEventType(.Value, withBlock: { snapshot in
            cell.noOfMembersLabel.text = "Members: \(String(snapshot.value!))"
        })
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let newGroup = Group(name: "temp")
        
            if segue.identifier == "displayGroup" {
                let displayGroupViewController = segue.destinationViewController as! DisplayGroupViewController
                let indexPath = tableView.indexPathForSelectedRow!
                let groupId = groupKeys[indexPath.row]
                print("Displaying a group")
                
                let ref = FIRDatabase.database().reference()
            
                let groupRef = ref.child("Groups").child(groupId)

                   _ = groupRef.child("name").observeEventType(.Value, withBlock: { snapshot in
                    newGroup.name = String(snapshot.value!)
                    print("snapshot \(snapshot.value!)")
                })
                _ = groupRef.child("noClaimed").observeEventType(.Value, withBlock: { snapshot in
                    newGroup.noClaimed = (snapshot.value as! Int)
                    print("snapshot2 \(snapshot.value as! Int)")
                })
                _ = groupRef.child("noOfMembers").observeEventType(.Value, withBlock: { snapshot in
                    newGroup.noOfMembers = (snapshot.value as! Int)
                    print("snapshot3 \(snapshot.value as! Int)")
                })
                _ = groupRef.child("noUnclaimed").observeEventType(.Value, withBlock: { snapshot in
                    newGroup.noUnclaimed = (snapshot.value as! Int)
                    print("snapshot4 \(snapshot.value as! Int)")
                })
                _ = groupRef.child("userNames").observeEventType(.Value, withBlock: { snapshot in
                   newGroup.userNames = (snapshot.value as! [String])
                    print("snapshot5 \(snapshot.value as! [String])")
                })
                _ = groupRef.child("userIds").observeEventType(.Value, withBlock: { snapshot in
                    newGroup.userIds = (snapshot.value as! [String])
                    print("snapshot6 \(snapshot.value as! [String])")
                    
                })
                
                displayGroupViewController.group = newGroup
                displayGroupViewController.groupId = groupId
            }
         else if segue.identifier == "addGroup" {
                let createGroupViewController = segue.destinationViewController as! CreateGroupViewController
            }
                
       
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return false
    }

    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        
    }
    
}
