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

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var nevermindButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var bodyTextView: UITextView!
    
    @IBAction func doneButtonAction(sender: AnyObject) {
        FIRDatabase.database().reference().child("Tasks").child(taskId!).child("done").setValue(1)
    }
    
    @IBAction func nevermindButtonAction(sender: AnyObject) {
        let ref = FIRDatabase.database().reference()
        ref.child("Tasks").child(taskId!).child("claimed").setValue(0)
        
        let groupRef = ref.child("Tasks").child(taskId!).child("group")
        groupRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            let groupId = String(snapshot.value!)
            let noUnclaimedRef = ref.child("Groups").child(groupId).child("noUnclaimed")
            noUnclaimedRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                print("int \(Int(snapshot.value as! NSNumber))")
                let noUnclaimed = Int(snapshot.value as! NSNumber)
                noUnclaimedRef.setValue(noUnclaimed + 1)
            })
        })
        
        ref.child("Users").child((FIRAuth.auth()?.currentUser!.uid)!).child("tasks").child(taskId!).removeValue()
        ref.child("Tasks").child(taskId!).child("done").setValue(0)
        ref.child("Tasks").child(taskId!).child("userNameClaimed").setValue(nil)
        ref.child("Tasks").child(taskId!).child("userIdClaimed").setValue(nil)
        ref.child("Tasks").child(taskId!).child("dateClaimed").setValue(nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.backgroundColor = orangeButtonColor
        doneButton.layer.cornerRadius = 10
        nevermindButton.backgroundColor = backgroundColor
        nevermindButton.layer.cornerRadius = 10
        view.backgroundColor = backgroundColor
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
