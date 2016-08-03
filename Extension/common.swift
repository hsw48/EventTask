//
//  common.swift
//  EventTask
//
//  Created by Harrison Woodward on 8/1/16.
//  Copyright © 2016 Harrison Woodward. All rights reserved.
//

import Foundation


func saveSession(session: String) {
    let userDefaults = NSUserDefaults(suiteName: "session")
    userDefaults?.setObject(session, forKey: "auth")
}

func currentDate() -> String {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateStyle = .MediumStyle
    dateFormatter.timeStyle = .NoStyle
    dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
    let currentDate = dateFormatter.stringFromDate(NSDate())
    return currentDate
    
}