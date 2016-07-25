//
//  Task.swift
//  EventTask
//
//  Created by Harrison Woodward on 7/13/16.
//  Copyright © 2016 Harrison Woodward. All rights reserved.
//

import Foundation
import Firebase


class Task {
    var name : String
    var body : String
    var datePosted : String
    var dateClaimed : String?
    var claimed : Bool = false
    var userClaimed : FIRUser?
    var userPosted: String
    var groupId : String?
    
    init(name: String, body: String, datePosted: String, userPosted: String, groupId: String) {
        self.name = name
        self.body = body
        self.datePosted = datePosted
        self.userPosted = userPosted
        self.groupId = groupId
        
    }
    
}
