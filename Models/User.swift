//
//  User.swift
//  EventTask
//
//  Created by Harrison Woodward on 7/13/16.
//  Copyright © 2016 Harrison Woodward. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

class User: FIRUser {
    
    var groups : [Group] = []
    var tasks : [Task] = []
    
}