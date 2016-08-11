//
//  DisplayMembersTableViewController.swift
//  EventTask
//
//  Created by Harrison Woodward on 8/2/16.
//  Copyright © 2016 Harrison Woodward. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class DisplayMembersTableViewController: UITableViewController {

    var group : Group?
    var groupId : String?
    var rowCount : Int = 0
    var names = [String]()
    var numbers = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = FIRDatabase.database().reference().child("Groups").child(groupId!).child("userNames")
        ref.observeEventType(.Value, withBlock: { snapshot in
             if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.rowCount = snapshots.count
            }
            self.tableView.reloadData()
        })
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addMember" {
            let vc = segue.destinationViewController as! AddMembersViewController
            vc.groupId = groupId!
        }
    }
    
//    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
//            let row = indexPath.row
//            let ref = FIRDatabase.database().reference()
//            let membersRef = ref.child("Groups").child(self.groupId!).child("userIds")
//            let userNameRef = ref.child("Groups").child(self.groupId!).child("userNames")
//            let tasksRef = ref.child("Groups").child(self.groupId!).child("tasks")
//            
//            membersRef.observeEventType(.Value, withBlock: { snapshot in
//                ref.child("Users").child(String(snapshot.value!)).child("tasks")
//            })
//            
//            membersRef.observeEventType(.Value, withBlock: { snapshot in
//                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
//                    membersRef.child(String(snapshots[row].value!)).removeValue()
//                    
//                }
//            })
//            userNameRef.observeEventType(.Value, withBlock: { snapshot in
//                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
//                    userNameRef.child(String(snapshots[row].value!)).removeValue()
//                }
//            })
//            
//            
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rowCount
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("memberCell", forIndexPath: indexPath) as! MembersTableViewCell
        let row = indexPath.row
        let ref = FIRDatabase.database().reference()
        
        let membersRef = ref.child("Groups").child(self.groupId!).child("userNames")
        
        membersRef.observeEventType(.Value, withBlock: { snapshot in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
               
                    cell.titleLabel.text = String(snapshots[row].value!)
                
            }
        })
        
       return cell
       
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }

}
