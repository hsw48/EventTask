//
//  DisplayGroupViewController.swift
//  EventTask
//
//  Created by Harrison Woodward on 7/20/16.
//  Copyright © 2016 Harrison Woodward. All rights reserved.
//

import UIKit

class DisplayGroupViewController: UIViewController {
    
    var group : Group?
    var groupId : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
     
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addTask" {
            let createTaskVC = segue.destinationViewController as! CreateTaskViewController
            createTaskVC.group = group
            createTaskVC.groupId = groupId
            
        }
    }
    
    override func viewWillAppear(animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  

}
