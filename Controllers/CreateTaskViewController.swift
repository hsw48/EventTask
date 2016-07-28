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
    
    var group : Group?
    var groupId : String?
   
    override func viewDidLoad() {
       nameTextField.delegate = self
        bodyTextView.delegate = self
        
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "cancel" {
            let displayGroupViewController = segue.destinationViewController as! DisplayGroupViewController

            print("Cancel")
            displayGroupViewController.group = group
            displayGroupViewController.groupId = groupId
            
        } else if segue.identifier == "saveTask" {
            let displayGroupViewController = segue.destinationViewController as! DisplayGroupViewController

            
       //   let date = NSDate().currentDate()
            
            displayGroupViewController.group = group
            displayGroupViewController.groupId = groupId
            
            group!.noUnclaimed += 1
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = .MediumStyle
            dateFormatter.timeStyle = .NoStyle
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
            
            let currentDate = dateFormatter.stringFromDate(NSDate())
            
            let task = Task(name: nameTextField.text! ,body:bodyTextView.text, datePosted: currentDate, userPosted: (FIRAuth.auth()?.currentUser!.displayName)!, groupId: groupId!)
    
            let taskData : NSDictionary = ["name": task.name, "body" :task.body, "datePosted" : task.datePosted, "userPosted": task.userPosted, "group": task.groupId!, "claimed" : task.claimed]
    
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
}

extension CreateTaskViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
extension CreateTaskViewController: UITextViewDelegate {
    
    func textViewShouldReturn(textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
}

