//
//  CreateGroupViewController.swift
//  EventTask
//
//  Created by Harrison Woodward on 7/13/16.
//  Copyright © 2016 Harrison Woodward. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class CreateGroupViewController: UIViewController {

    var group : Group?
    var groupId : String?
    
    @IBOutlet weak var addMembersTextField: UITextField!
    @IBOutlet weak var groupNameTextField: UITextField!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     //   let groupsTableViewController = segue.destinationViewController as! GroupsTableViewController
        if segue.identifier == "cancel" {
            print("Cancel")
        } else if segue.identifier == "save" {
            
            
            let event = Group(name: groupNameTextField.text!)
            
            event.noClaimed = 0
            event.noOfMembers = 1
            event.noUnclaimed = 0
            event.tasks = []
           
            event.userNames = [(FIRAuth.auth()?.currentUser!.displayName)!]
            event.userIds = [(FIRAuth.auth()?.currentUser!.uid)!]
            
            let vc = GroupsTableViewController()
            vc.groups.append(event)
            
            let eventData : NSDictionary = ["name" : event.name, "noClaimed" : event.noClaimed, "noUnclaimed" : event.noUnclaimed, "noOfMembers" : event.noOfMembers,"tasks" : event.tasks,"userNames" : event.userNames, "userIds" : event.userIds]
           
            // generate unique group ID
           
            let uuid = NSUUID().UUIDString
           
            //save group in Groups Firebase
            
            let ref = FIRDatabase.database().reference()
            let groupAutoIdref : FIRDatabaseReference =  ref.child("Groups").child(uuid)
            groupAutoIdref.setValue(eventData)
            
            // add reference to group to User's groups Firebase
            
            let newGroup : NSDictionary = [uuid : "https://eventtask-40794.firebaseio.com/Groups/\(uuid)"]
            ref.child("Users").child((FIRAuth.auth()?.currentUser!.uid)!).child("groups").updateChildValues(newGroup as [NSObject : AnyObject])
            
            
        }
    }
    
    override func viewDidLoad() {
        groupNameTextField.delegate = self
        addMembersTextField.delegate = self
        
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension CreateGroupViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
