//
//  DisplayTaskViewController.swift
//  EventTask
//
//  Created by Julia Woodward on 7/26/16.
//  Copyright © 2016 Harrison Woodward. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class DisplayTaskViewController: UIViewController {
    
    var taskId : String?
    var group : Group?
    var unclaimedTasks = [String?]()
    
    var taskRef : FIRDatabaseReference! = nil
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var postedLabel: UILabel!
    
    @IBOutlet weak var claimButton: UIButton!
    @IBAction func claimButtonAction(sender: AnyObject) {
        let button = sender as? UIButton
        print(button!.tag)
        let ref = FIRDatabase.database().reference()
        ref.child("Tasks").child(taskId!).child("claimed").setValue(1)
        unclaimedTasks.removeAtIndex(button!.tag)
        group!.noUnclaimed -= 1
        ref.child("Tasks").child(taskId!).child("userNameClaimed").setValue((FIRAuth.auth()?.currentUser!.displayName)!)
        ref.child("Tasks").child(taskId!).child("userIdClaimed").setValue((FIRAuth.auth()?.currentUser!.uid)!)
        let newTask : NSDictionary = [taskId! : "https://eventtask-40794.firebaseio.com/Users/\((FIRAuth.auth()?.currentUser!.uid)!)/\(taskId)"]
        ref.child("Users").child((FIRAuth.auth()?.currentUser!.uid)!).child("tasks").updateChildValues((newTask as [NSObject : AnyObject]))
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .NoStyle
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
        let currentDate = dateFormatter.stringFromDate(NSDate())
        ref.child("Tasks").child(taskId!).child("dateClaimed").setValue(currentDate)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskRef = FIRDatabase.database().reference().child("Tasks").child(taskId!)
        
        var datePosted : String = "unknown date"
        let nameRef = taskRef.child("name")
        
        _ = nameRef.observeEventType(.Value, withBlock: { snapshot in
           self.titleLabel.text = String(snapshot.value!)
        })
        let bodyRef = taskRef.child("body")
        _ = bodyRef.observeEventType(.Value, withBlock: { snapshot in
            self.bodyTextView.text = String(snapshot.value!)
        })
        let datePostedRef = taskRef.child("datePosted")
        _ = datePostedRef.observeEventType(.Value, withBlock: {snapshot in
            datePosted = String(snapshot.value!)
        })
        let userPostedRef = taskRef.child("userPosted")
        _ = userPostedRef.observeEventType(.Value, withBlock: { snapshot in
            self.postedLabel.text = "\(String(snapshot.value!)) posted this on \(datePosted)"
        })
        
        
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    



}
