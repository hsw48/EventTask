//
//  Task.swift
//  EventTask
//
//  Created by Harrison Woodward on 7/13/16.
//  Copyright © 2016 Harrison Woodward. All rights reserved.
//

import Foundation


class Task {
    var name : String
    var datePosted : NSDate
    var dateClaimed : NSDate?
    var claimed : Bool = false
    var userClaimed : User?
    var userPosted: User
    var group : Group
    
    init(name: String, datePosted: NSDate, userPosted: User, group: Group) {
        self.name = name
        self.datePosted = datePosted
        self.userPosted = userPosted
        self.group = group
        
    }
    
}
