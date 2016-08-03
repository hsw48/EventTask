//
//  Group.swift
//  EventTask
//
//  Created by Harrison Woodward on 7/13/16.
//  Copyright © 2016 Harrison Woodward. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth


class Group {
    var name : String
    var noOfMembers : Int
    var noClaimed : Int
    var noUnclaimed : Int
    var userNames : [String] = []
    var userIds : [String] = []
    var tasks : [NSDictionary] = []
    
    init(name: String) {
        self.name = name
        self.noUnclaimed = 0
        self.noClaimed = 0
        self.noOfMembers = 1
    }
}
