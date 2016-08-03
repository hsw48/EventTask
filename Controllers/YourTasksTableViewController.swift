//
//  YourTasksTableViewController.swift
//  EventTask
//
//  Created by Harrison Woodward on 7/13/16.
//  Copyright © 2016 Harrison Woodward. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class YourTasksTableViewController: UITableViewController {
 
    var tasks = [String?]()
    let ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        self.tableView.reloadData()
        super.viewDidLoad()
    }
    override func viewWillAppear(animated: Bool) {
        let tasksRef = ref.child("Users").child((FIRAuth.auth()?.currentUser)!.uid).child("tasks")
        tasksRef.observeEventType(.Value, withBlock: { snapshot in
            if self.tasks.count < snapshot.children.allObjects.count {
                self.tasks = []
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    for snap in snapshots {
                        self.tasks.append(String(snap.key))
                    }
                }
            }
            self.tableView.reloadData()
        })
        super.viewWillAppear(true)
    }
    
    override func viewDidAppear(animated: Bool){
        
        super.viewDidAppear(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
   
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = tasks.count
        return count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("YourTasksCell", forIndexPath: indexPath) as! YourTasksTableViewCell
       
        
        let row = indexPath.row
        
        //set labels of task cells
        let ref = FIRDatabase.database().reference()
        
        let doneRef = ref.child("Tasks").child(tasks[row]!).child("done")
        doneRef.observeEventType(.Value, withBlock: { snapshot in
            print("snapshotttt \(snapshot.value! as! NSObject)")
            if snapshot.value! as! NSObject == 0 {
                cell.backgroundColor = UIColor(red:1,green:0.8,blue:0.82,alpha:1)
            } else if snapshot.value! as! NSObject == 1 {
                cell.backgroundColor = UIColor(red:0.78,green:0.90,blue:0.79,alpha:1)
            }
            
        })
        
        let nameRef = ref.child("Tasks").child(tasks[row]!).child("name")
        nameRef.observeEventType(.Value, withBlock: { snapshot in
           
            print("task name \(snapshot.value!)")
            cell.titleLabel.text = String(snapshot.value!)
        })
      
        let groupRef = ref.child("Tasks").child(tasks[row]!).child("group")
        groupRef.observeEventType(.Value, withBlock: { snapshot in
            let groupNameRef = ref.child("Groups").child(snapshot.value as! String).child("name")
            groupNameRef.observeEventType(.Value, withBlock: { snapshot in
                cell.detailLabel.text = String(snapshot.value!)
            })
        })

        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ViewTask" {
        let yourTaskViewController = segue.destinationViewController as! YourTaskViewController
        
            let indexPath = tableView.indexPathForSelectedRow!
            let taskId : String = tasks[indexPath.row]!
            
            yourTaskViewController.taskId = taskId
       //     yourTaskViewController.group = self.group!
        //    yourTaskViewController.unclaimedTasks = self.unclaimedTasks
        
            }
        }
        
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        
    }

}
