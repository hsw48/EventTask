//
//  CreateGroupViewController.swift
//  EventTask
//
//  Created by Harrison Woodward on 7/13/16.
//  Copyright © 2016 Harrison Woodward. All rights reserved.
//

import UIKit

class CreateGroupViewController: UIViewController {

    @IBOutlet weak var addMembersTextField: UITextField!
    @IBOutlet weak var groupNameTextField: UITextField!

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let groupsTableViewController = segue.destinationViewController as! GroupsTableViewController
        if segue.identifier == "cancel" {
            print("Cancel")
        } else if segue.identifier == "save" {
            let event = Group(name: groupNameTextField.text!)
            
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
