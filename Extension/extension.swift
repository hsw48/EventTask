//
//  extension.swift
//  EventTask
//
//  Created by Harrison Woodward on 8/1/16.
//  Copyright © 2016 Harrison Woodward. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@", argumentArray: [emailRegEx])
        
        return emailTest.evaluateWithObject(self)
    }
}

extension UIViewController {
    func presentAlertController(title: String, message: String) {
        let controller = UIAlertController.showOKAlert(title, message:
            message)
        self.presentViewController(controller, animated: true, completion: nil)
    }
}
extension UIAlertController {
    class func showOKAlert(title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "Ok",
                                         style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        return alertController
    }
}
