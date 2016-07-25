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

            print("unclaimed: \(group!.noUnclaimed)")
            
            let task = Task(name: nameTextField.text! ,body:bodyTextView.text, datePosted: "10/3/1994", userPosted: (FIRAuth.auth()?.currentUser!.displayName)!, groupId: groupId!)
    
            let taskData : NSDictionary = ["name": task.name, "body" :task.body, "datePosted" : task.datePosted, "userPosted": task.userPosted, "group": task.groupId!]
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
