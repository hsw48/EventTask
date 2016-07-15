//
//  User.swift
//  EventTask
//
//  Created by Harrison Woodward on 7/13/16.
//  Copyright © 2016 Harrison Woodward. All rights reserved.
//

import Foundation


class User {
    var name : String
    var email : String
    var pw : String
    var groups : [Group] = []
    var tasks : [Task] = []
    
    init(name: String, email: String, pw: String){
        self.name = name
        self.email = email
        self.pw = pw
    }
}