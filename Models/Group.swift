//
//  Group.swift
//  EventTask
//
//  Created by Harrison Woodward on 7/13/16.
//  Copyright © 2016 Harrison Woodward. All rights reserved.
//

import Foundation

class Group {
    var name : String
    var noOfMembers = 1
    var noClaimed = 0
    var noUnclaimed = 0
    var users : [User] = []
    var tasks : [Task] = []
    
    init(name: String) {
        self.name = name
    }
}
