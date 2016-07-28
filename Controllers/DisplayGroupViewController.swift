//
//  DisplayGroupViewController.swift
//  EventTask
//
//  Created by Harrison Woodward on 7/20/16.
//  Copyright © 2016 Harrison Woodward. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class DisplayGroupViewController: UIViewController, UITableViewDelegate {
    
    
    var group : Group?
    var groupId : String?
    var claimedTasks = [String?]()
    var unclaimedTasks = [String?]()
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBAction func segmentedControlChange(sender: AnyObject) {
        getData()
    }
    @IBAction func claimButtonAction(sender: AnyObject) {
        let button = sender as? UIButton
        print(button!.tag)
        let taskId = unclaimedTasks[button!.tag]
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
        getData()
    }
 
    override func viewDidLoad() {
        
        segmentedControl.selectedSegmentIndex = 1
        getData()
        super.viewDidLoad()
    }
    
    func getData(){
        if self.segmentedControl.selectedSegmentIndex == 0 {
            createClaimedTasksArray()
        } else if segmentedControl.selectedSegmentIndex == 1{
            print("get Data index 1")
           createUnclaimedTasksArray()
        }
    }
        
    
    func createClaimedTasksArray() {
        var claimedTasksLocal = [String?]()
        var allTasks = [FIRDataSnapshot]()
        let ref = FIRDatabase.database().reference()
        let tasksRef = ref.child("Groups").child(groupId!).child("tasks")
        tasksRef.observeEventType(.Value, withBlock: {snapshot in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    allTasks.append(snap)
                }
            }
        for task in allTasks {
            ref.child("Tasks").child(task.key).child("claimed").observeEventType(.Value, withBlock: { (snapshot) in
                if snapshot.value as! NSObject == 1 {
                    claimedTasksLocal.append(String(task.key))
                }
                self.claimedTasks = claimedTasksLocal
                self.tableView.reloadData()
            })
        }
            
        })
    }
        
    func createUnclaimedTasksArray() {
        var unclaimedTasksLocal = [String?]()
        var allTasks = [FIRDataSnapshot]()
        let ref = FIRDatabase.database().reference()
        let tasksRef = ref.child("Groups").child(groupId!).child("tasks")
        tasksRef.observeEventType(.Value, withBlock: {snapshot in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    allTasks.append(snap)
                }
            }
        for task in allTasks {
            ref.child("Tasks").child(task.key).child("claimed").observeEventType(.Value, withBlock: { (snapshot) in
                if snapshot.value as! NSObject == 0 {
                    unclaimedTasksLocal.append(String(task.key))
                }
                self.unclaimedTasks = unclaimedTasksLocal
                self.tableView.reloadData()
            })
            }
           
        })
    }

    override func viewDidAppear(animated: Bool) {
     
       
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = 0
        if segmentedControl.selectedSegmentIndex == 0 {
            rowCount = claimedTasks.count
        } else {
            rowCount = unclaimedTasks.count
        }
        
        return rowCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if segmentedControl.selectedSegmentIndex == 0 {
            //claimed cell label
         
            let cell = tableView.dequeueReusableCellWithIdentifier("claimedCell", forIndexPath: indexPath) as! ClaimedTableViewCell
            
            let row = indexPath.row
            let ref = FIRDatabase.database().reference()
            let nameRef = ref.child("Tasks").child(claimedTasks[row]!).child("name")
            _ = nameRef.observeEventType(.Value, withBlock: { snapshot in
                cell.titleLabel.text = String(snapshot.value!)
            })
            var date = ""
            let dateRef = ref.child("Tasks").child(claimedTasks[row]!).child("dateClaimed")
            dateRef.observeEventType(.Value, withBlock: { snapshot in
                date = String(snapshot.value!)
            })
            let unclaimedRef = ref.child("Tasks").child(claimedTasks[row]!).child("userNameClaimed")
            _ = unclaimedRef.observeEventType(.Value, withBlock: { snapshot in
                let name = String(snapshot.value!).componentsSeparatedByString(" ")
                cell.detailLabel.text = "Claimed by \(String(name[0])) \n on \(date)"
            })
         return cell
            
        } else {
            //unclaimed cell labels
           
            let cell = tableView.dequeueReusableCellWithIdentifier("unclaimedCell", forIndexPath: indexPath) as! UnclaimedTableViewCell
            
            cell.claimButton.tag = indexPath.row
            
            let row = indexPath.row
            let ref = FIRDatabase.database().reference()
            let nameRef = ref.child("Tasks").child(unclaimedTasks[row]!).child("name")
            nameRef.observeEventType(.Value, withBlock: { snapshot in
                print("cell snapshot \(String(snapshot.value!))")
                cell.nameLabel.text = String(snapshot.value!)
            })
            return cell
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addTask" {
            let createTaskVC = segue.destinationViewController as! CreateTaskViewController
            createTaskVC.group = group
            createTaskVC.groupId = groupId
        }
        if segue.identifier == "displayTask" {
            print("Displaying a task")
            let indexPath = tableView.indexPathForSelectedRow!
            var taskId : String
            if segmentedControl.selectedSegmentIndex == 0 {
                taskId = claimedTasks[indexPath.row]!
            } else {
                taskId = unclaimedTasks[indexPath.row]!
            }
                let displayTaskViewController = segue.destinationViewController as! DisplayTaskViewController
                displayTaskViewController.taskId = taskId
                displayTaskViewController.group = self.group!
                displayTaskViewController.unclaimedTasks = self.unclaimedTasks
                
            
        }
    }
        
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.title = group!.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        
    }
    
    

  

}
