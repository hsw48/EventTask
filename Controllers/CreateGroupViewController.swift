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
    var numbers = [String]()
    var names = [String]()
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var addContactsButton: UIButton!
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var numbersTextView: UITextView!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBAction func enterAction(sender: AnyObject) {
        var namesFormatted : String = ""
        if phoneNumberTextField.text?.characters.count == 10 {
            names.append(phoneNumberTextField.text!)
            numbers.append(phoneNumberTextField.text!)
            let namesString = String(names)
            namesFormatted = (String(namesString.characters.filter({ !["[", "]", "\""].contains($0) })))
           
            phoneNumberTextField.text = ""
        } else {print("Invalid number. Ex: 2223334444")}
        numbersTextView.text = namesFormatted
        
    }
    
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
            if  FIRAuth.auth()?.currentUser!.displayName != nil {
                event.userNames = [(FIRAuth.auth()?.currentUser!.displayName)!]
            } else {
                event.userNames = [(FIRAuth.auth()?.currentUser!.email)!]
            }
            event.userIds = [(FIRAuth.auth()?.currentUser!.uid)!]
            
            let vc = GroupsTableViewController()
            vc.groups.append(event)
            
           
            
            // generate unique group ID
           
            let uuid = NSUUID().UUIDString
           
            //save group in Groups Firebase
            
            let ref = FIRDatabase.database().reference()
            ref.child("Groups").child(uuid).child("userIds").updateChildValues([(FIRAuth.auth()?.currentUser!.uid)! : "https://eventtask-40794.firebaseio.com/Users/\(FIRAuth.auth()?.currentUser!.uid)"])
         
            
            // add reference to group to User's groups Firebase
            
            let newGroup : NSDictionary = [uuid : "https://eventtask-40794.firebaseio.com/Groups/\(uuid)"]
            ref.child("Users").child((FIRAuth.auth()?.currentUser!.uid)!).child("groups").updateChildValues(newGroup as [NSObject : AnyObject])
            
            // add other people to Group via their mobile phone number
            for number in numbers {
                print("number \(number)")
                // check if phone number is in database: snapshot.value = phone number's userId
                    ref.child("Phone Numbers").child(number).observeEventType(.Value, withBlock: { snapshot in
                        
                        if snapshot.value! is String {
                            print("adding number")
                            let newUserId = snapshot.value as! String
                            ref.child("Users").child(newUserId).child("groups").updateChildValues(newGroup as [NSObject : AnyObject])
                        
                            // snapshot.value = phone number's userName
                            let userName = ref.child("Users").child(newUserId).child("name")
                            userName.observeEventType(.Value, withBlock: { snapshot in
                                let newUserName = snapshot.value as! String
                            
                                event.userIds.append(newUserId)
                                event.userNames.append(newUserName)
                                print("done")
                                let eventData : NSDictionary = ["name" : event.name, "noClaimed" : event.noClaimed, "noUnclaimed" : event.noUnclaimed, "noOfMembers" : event.userIds.count,"tasks" : event.tasks,"userNames" : event.userNames, "userIds" : event.userIds]
                                
                                let groupAutoIdref : FIRDatabaseReference = ref.child("Groups").child(uuid)
                                groupAutoIdref.setValue(eventData)
                            })
                        }
                    
                        else {print("phone number does not exist")}
                       
                    })}
            let eventData : NSDictionary = ["name" : event.name, "noClaimed" : event.noClaimed, "noUnclaimed" : event.noUnclaimed, "noOfMembers" : event.userIds.count,"tasks" : event.tasks,"userNames" : event.userNames, "userIds" : event.userIds]
            
            let groupAutoIdref : FIRDatabaseReference = ref.child("Groups").child(uuid)
            groupAutoIdref.setValue(eventData)
        } else {
            let vc = segue.destinationViewController as! ContactsViewController
            vc.numbers = numbers
            vc.names = names
        }
    }
    

    override func viewDidAppear(animated: Bool) {
        let namesString = String(names)
           let namesFormatted = (String(namesString.characters.filter({ !["[", "]", "\""].contains($0) })))
           numbersTextView.text = String(namesFormatted)
        print("appear")
       
    }
    
    override func viewDidLoad() {

        print("load")
        addTapGesture()
        super.viewDidLoad()
        view.backgroundColor = backgroundColor
       
        addButton.layer.cornerRadius = 10
        addButton.backgroundColor = purpleButtonColor
        addButton.tintColor = fontColor
      
        addContactsButton.layer.cornerRadius = 10
        addContactsButton.backgroundColor = purpleButtonColor
        addContactsButton.tintColor = fontColor
      
        saveButton.backgroundColor = orangeButtonColor
        saveButton.tintColor = fontColor
       
        numbersTextView.backgroundColor = backgroundColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        
    }
    func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action:
            #selector(CreateGroupViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

}


