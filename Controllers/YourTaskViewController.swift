//
//  YourTaskViewController.swift
//  EventTask
//
//  Created by Harrison Woodward on 7/28/16.
//  Copyright © 2016 Harrison Woodward. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class YourTaskViewController: UIViewController {
    
    var taskId : String?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var bodyTextView: UITextView!
    
    @IBAction func doneButtonAction(sender: AnyObject) {
        FIRDatabase.database().reference().child("Tasks").child(taskId!).child("done").setValue(1)
    }
    
    @IBAction func nevermindButtonAction(sender: AnyObject) {
     FIRDatabase.database().reference().child("Tasks").child(taskId!).child("claimed").setValue(0)
     FIRDatabase.database().reference().child("Users").child((FIRAuth.auth()?.currentUser!.uid)!).child("tasks").child(taskId!).removeValue()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let ref = FIRDatabase.database().reference()
        let nameRef = ref.child("Tasks").child(taskId!).child("name")
        nameRef.observeEventType(.Value, withBlock:  { snapshot in
            self.titleLabel.text = String(snapshot.value!)
        })
        
        let groupRef = ref.child("Tasks").child(taskId!).child("group")
        groupRef.observeEventType(.Value, withBlock: { snapshot in
            let groupNameRef = ref.child("Groups").child(String(snapshot.value!)).child("name")
            groupNameRef.observeEventType(.Value, withBlock: { snapshot in
            self.groupLabel.text = String(snapshot.value!)
                
            })
        })
        let bodyRef = ref.child("Tasks").child(taskId!).child("body")
        bodyRef.observeEventType(.Value) { snapshot in
            self.bodyTextView.text = String(snapshot.value!)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
