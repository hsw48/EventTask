//
//  CreateTaskViewController.swift
//  EventTask
//
//  Created by Harrison Woodward on 7/13/16.
//  Copyright © 2016 Harrison Woodward. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class CreateTaskViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    @IBOutlet weak var doneButton: UIButton!
    var group : Group?
    var groupId : String?
   
    override func viewDidLoad() {
        addTapGesture()
        super.viewDidLoad()
        view.backgroundColor = backgroundColor
        doneButton.backgroundColor = orangeButtonColor
        doneButton.tintColor = fontColor
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "cancel" {
            let displayGroupViewController = segue.destinationViewController as! DisplayGroupViewController

            print("Cancel")
            displayGroupViewController.group = group
            displayGroupViewController.groupId = groupId
            
        } else if segue.identifier == "saveTask" {
            let displayGroupViewController = segue.destinationViewController as! DisplayGroupViewController
            displayGroupViewController.group = group
            displayGroupViewController.groupId = groupId
            
            group!.noUnclaimed += 1
            
            var task = Task(name: "temp", body: "temp", datePosted: "temp", userPosted: "temp", groupId: "temp")
            if (FIRAuth.auth()?.currentUser!.displayName) != nil {
                task = Task(name: nameTextField.text! ,body:bodyTextView.text, datePosted: currentDate(), userPosted: (FIRAuth.auth()?.currentUser!.displayName)!, groupId: groupId!)
            } else {
                task = Task(name: nameTextField.text! ,body:bodyTextView.text, datePosted: currentDate(), userPosted: (FIRAuth.auth()?.currentUser!.email)!, groupId: groupId!)
            }
           task.claimed = 0
    
            let taskData : NSDictionary = ["name" : task.name, "body" : task.body, "datePosted" : task.datePosted, "userPosted" : task.userPosted, "group" : task.groupId!, "claimed" : task.claimed]
    
            let ref = FIRDatabase.database().reference()
            ref.child("Groups").child(groupId!).child("noUnclaimed").setValue(group!.noUnclaimed)
            let uuid = NSUUID().UUIDString
            let taskRef = ref.child("Tasks").child(uuid)
            taskRef.setValue(taskData)
            let newTask : NSDictionary = [uuid : "https://eventtask-40794.firebaseio.com/Tasks/\(uuid)"]
            ref.child("Groups").child(groupId!).child("tasks").updateChildValues((newTask as [NSObject : AnyObject]))
            
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action:
            #selector(CreateTaskViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}


