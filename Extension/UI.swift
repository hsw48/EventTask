//
//  UI.swift
//  EventTask
//
//  Created by Harrison Woodward on 8/2/16.
//  Copyright © 2016 Harrison Woodward. All rights reserved.
//

import Foundation
import UIKit

// incomplete task : #FFCDD2 or darker: #EF9A9A
//complete task : #C8E6C9 or #A5D6A7

func applyTheme() {
    let sharedApplication = UIApplication.sharedApplication()
    sharedApplication.delegate?.window??.tintColor = barTintColor

    styleForNavigationBar()
    styleForTabBar()
}


func styleForNavigationBar() {
    UINavigationBar.appearance().barTintColor = barTintColor
    UINavigationBar.appearance().tintColor = UIColor.whiteColor()
    UINavigationBar.appearance().titleTextAttributes = [ /*NSFontAttributeName: UIFont.standardTextFont,  */NSForegroundColorAttributeName: UIColor.whiteColor()]
}

func styleForTabBar() {
    UITabBar.appearance().barTintColor = barTintColor
    UITabBar.appearance().tintColor = UIColor.whiteColor()
}

/*
 
 var barTintColor: UIColor {
 return UIColor(red: 49.0/255.0, green: 169.0/255.0, blue: 247.0/255.0, alpha: 1.0)
 }
 
 */

var backgroundColor : UIColor{
    return UIColor(red:0.70, green:0.62, blue:0.86, alpha:1.0)
   
   // return  UIColor(red:0.42, green:0.55, blue:0.66, alpha:1.0)
}

var barTintColor: UIColor {
    return UIColor(red:0.40, green:0.23, blue:0.72, alpha:1.0)
  //  return UIColor(red:0.20, green:0.36, blue:0.50, alpha:1.0)
}

// yellow: UIColor(red:1.00, green:1.00, blue:0.00, alpha:1.0)

var orangeButtonColor: UIColor {
    return UIColor(red:1.00, green:0.57, blue:0.00, alpha:1.0)
   // return UIColor(red:1.00, green:1.00, blue:0.00, alpha:1.0)
}

var purpleButtonColor: UIColor {
    return UIColor(red:0.27, green:0.15, blue:0.63, alpha:1.0)
  //  return UIColor(red:0.05, green:0.22, blue:0.36, alpha:1.0)
}

var fontColor: UIColor {
    return UIColor.whiteColor()
}

//extension UIFont {
//    class var standardTextFont: UIFont {
//        return UIFont(name: "HelveticaNeue-Bold", size: 15)!
//    }
//}


/* Purple with teal accent
 
 primary: #673AB&
 light: #9575CD OR #B39DDB or lighter #D1C4E9
 dark: #4527A0 or darker #311B92
 accent: #68efad (teal) or #fff176 (yellow) or #ffb74d (orange) or #ef946c (salmon)
 */